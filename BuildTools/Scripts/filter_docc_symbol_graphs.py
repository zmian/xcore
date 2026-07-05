#!/usr/bin/env python3
"""Filter Xcore DocC symbol graphs before static-site conversion.

Why this exists
---------------
Xcore intentionally re-exports a few dependency modules with ``@_exported
import`` so package users can write ``import Xcore`` and still use dependency
types that are part of Xcore's public API surface. Xcode's DocC build treats
those re-exported dependency symbols as if they belong to Xcore. For example,
types owned by Clocks, AnyCodable, Dependencies, or KeychainAccess can appear
under URLs such as:

    /documentation/xcore/anyclock
    /documentation/xcore/anycodable
    /documentation/xcore/dependencyvalues

Those pages are not Xcore documentation; they duplicate third-party API
references in Xcore's namespace and make the generated site misleading.

There is no stable DocC or xcodebuild flag that says "document this target, but
exclude symbols introduced only by re-exported external modules." The supported
DocC pipeline is symbol-graph based: Xcode/Swift emits ``*.symbols.json`` files,
and DocC converts those symbol graphs into an archive/static site. This script
keeps that pipeline intact, but inserts one deterministic pruning step between
symbol graph extraction and ``docc convert``.

What it keeps
-------------
The filter preserves:

* Symbols whose Swift precise identifier is owned by the Xcore module.
* Xcore-authored extensions on external types, which Xcode emits in
  ``Xcore@Framework.symbols.json`` files. These are real Xcore APIs even though
  their extended type lives in Swift, Foundation, SwiftUI, UIKit, etc.

What it drops
-------------
The filter removes re-exported dependency symbols that are emitted into
``Xcore.symbols.json`` but whose precise identifiers are owned by another
module. These are the polluted dependency pages.

Tradeoffs
---------
This is deliberately narrower than post-processing the generated DocC site.
Pruning before ``docc convert`` lets DocC build a consistent navigator, index,
and relationship graph from the filtered inputs. Deleting generated HTML/JSON
after conversion would leave stale references in DocC's indexes.

The cleaner long-term fix would be a Swift/DocC-supported way to hide
re-exported dependency symbols from symbol graphs while preserving source and
client ergonomics. If Xcode/Swift gains that behavior, this script should be
removed and ``make build-docc`` should go back to the native DocC path.
"""

import argparse
import json
from pathlib import Path


MODULE_NAME = "Xcore"
MANGLED_MODULE_NAME = f"{len(MODULE_NAME)}{MODULE_NAME}"
XCORE_MODULE_PREFIX = f"s:{MANGLED_MODULE_NAME}"


def keep_symbol(symbol, source_name):
    precise_id = symbol.get("identifier", {}).get("precise", "")

    if precise_id.startswith(XCORE_MODULE_PREFIX):
        return True

    # Keep Xcore-authored extensions emitted in Xcore@Framework symbol graphs
    # while dropping re-exported third-party root symbols in Xcore.symbols.json.
    return source_name != "Xcore.symbols.json" and MANGLED_MODULE_NAME in precise_id


def load_symbol_graphs(input_dir):
    graphs = []

    for path in sorted(input_dir.glob("Xcore*.symbols.json")):
        with path.open(encoding="utf-8") as file:
            graphs.append((path, json.load(file)))

    if not graphs:
        raise SystemExit(f"No Xcore symbol graphs found in {input_dir}")

    return graphs


def main():
    parser = argparse.ArgumentParser(
        description="Filter DocC symbol graphs to Xcore-owned symbols."
    )
    parser.add_argument("input_dir", type=Path)
    parser.add_argument("output_dir", type=Path)
    args = parser.parse_args()

    graphs = load_symbol_graphs(args.input_dir)
    args.output_dir.mkdir(parents=True, exist_ok=True)

    original_ids = set()
    kept_ids = set()
    total_symbols = 0

    for path, graph in graphs:
        for symbol in graph.get("symbols", []):
            total_symbols += 1
            precise_id = symbol.get("identifier", {}).get("precise")
            if precise_id:
                original_ids.add(precise_id)
                if keep_symbol(symbol, path.name):
                    kept_ids.add(precise_id)

    dropped_ids = original_ids - kept_ids
    kept_symbols = 0

    for path, graph in graphs:
        symbols = []

        for symbol in graph.get("symbols", []):
            precise_id = symbol.get("identifier", {}).get("precise")
            if precise_id in kept_ids:
                symbols.append(symbol)

        graph["symbols"] = symbols
        graph["relationships"] = [
            relationship
            for relationship in graph.get("relationships", [])
            if relationship.get("source") not in dropped_ids
            and relationship.get("target") not in dropped_ids
        ]

        kept_symbols += len(symbols)
        with (args.output_dir / path.name).open("w", encoding="utf-8") as file:
            json.dump(graph, file, separators=(",", ":"))
            file.write("\n")

    print(f"Filtered DocC symbols: kept {kept_symbols} of {total_symbols}")


if __name__ == "__main__":
    main()
