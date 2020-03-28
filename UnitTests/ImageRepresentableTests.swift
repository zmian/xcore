//
// Xcore
// Copyright © 2020 Xcore
// MIT license, see LICENSE file for details
//

import XCTest
@testable import Xcore

final class ImageRepresentableTests: TestCase {
    func testCodable() throws {
        let values: [ImageSourceType] = [
            .url("arrow"),
            .url("http://example.com/avatar.png"),
            .uiImage(UIImage(assetIdentifier: .arrowLeftIcon))
        ]

        let encoder = JSONEncoder()
        let data = try encoder.encode(values)
        let encodedValue = String(data: data, encoding: .utf8)!
        let expectedEncodedValue = "[\"arrow\",\"http:\\/\\/example.com\\/avatar.png\",\"iVBORw0KGgoAAAANSUhEUgAAABsAAAAwCAQAAABKtskrAAAM82lDQ1BrQ0dDb2xvclNwYWNlR2VuZXJpY0dyYXlHYW1tYTJfMgAAWIWlVwdYU8kWnluS0BJ6lRI60gwoXUqkBpBeBFGJIZBACDEFAbEhiyu4dhHBsqKiKIsdgcWGBQtrB7sLuigo6+IqNixvEopYdt\\/7vnfzzb3\\/nXPOnDpnbgBQ5TAFAh4KAMjki4WBUfSEKQmJVNJdIAe0gTKwB8pMlkhAj4gIhSyAn8Vng2+uV+0AkT6v2UnX+pb+rxchhS1iwedxOHJTRKxMAJCJAJC6WQKhGAB5MzhvOlsskOIgiDUyYqJ8IU4CQE5pSFZ6GQWy+Wwhl0UNFDJzqYHMzEwm1dHekRohzErl8r5j9f97ZfIkI7rhUBJlRIfApz20vzCF6SfFrhDvZzH9o4fwk2xuXBjEPgCgJgLxpCiIgyGeKcmIpUNsC3FNqjAgFmIviG9yJEFSPAEATCuPExMPsSHEwfyZYeEQu0PMYYl8EyG2griSw2ZI8wRjhp3nihkxEEN92DNhVpSU3xoAfGIK289\\/cB5PzcgKkdpgAvFBUXa0\\/7DNeRzfsEFdeHs6MzgCYguIX7J5gVGD6xD0BOII6ZrwneDH54WFDvpFKGWLZP7Cd0K7mBMjzZkjAEQTsTAmatA2YkwqN4ABcQDEORxhUNSgv8SjAp6szmBMiO+FkqjYQR9JAWx+rHRNaV0sYAr9AwdjRWoCcQgTsEEWmAnvLMAHnYAKRIALsmUoDTBBJhxUaIEtHIGQiw+HEHKIQIaMQwi6RujDElIZAaRkgVTIyYNyw7NUkALlB+Wka2TBIX2Trtstm2MN6bOHw9dwO5DANw7ohXQORJNBh2wmB9qXCZ++cFYCaWkQj9YyKB8hs3XQBuqQ9T1DWrJktjBH5D7b5gvpfJAHZ0TDnuHaOA0fD4cHHop74jSZlBBy5AI72fxE2dyw1s+eS33rGdE6C9o62vvR8RqO4QkoJYbvPOghfyg+ImjNeyiTMST9lZ8r9CRWAkHpskjG9KoRK6gFwhlc1qXlff+StW+1232Rt\\/DRdSGrlJRv6gLqIlwlXCbcJ1wHVPj8g9BG6IboDuEu\\/N36blSyRmKQBkfWSAWwv8gNG3LyZFq+tfNzzgbX+WoFBBvhpMtWkVIz4eDKeEQj+ZNALIb3VJm03Ve5C\\/xab0t+kw6gti89fg5Qa1Qazn6Odhten3RNqSU\\/lb9CTyCYXpU\\/wBZ8pkrzwF4c9ioMFNjS9tJ6adtoNbQXtPufOWg3aH\\/S2mhbIOUptho7hB3BGrBGrBVQ4VsjdgJrkKEarAn+9v1Dhad9p8KlFcMaqmgpVTxUU6Nrf3Rk6aOiJeUfjnD6P9Tr6IqRZux\\/s2j0Ol92BPbnXUcxpThQSBRrihOFTkEoxvDnSPGByJRiQgmlaENqEMWS4kcZMxKP4VrnDWWY+8X+HrQ4AVKHK4Ev6y5MyCnlYA75+7WP1C+8lHrGHb2rEDLcVdxRPeF7vYj6xc6KhbJcMFsmL5Ltdr5MTvBF\\/YlkXQjOIFNlOfyObbgh7oAzYAcKB1ScjjvhPkN4sCsN9yVZpnBvSPXC\\/XBXaR\\/7oi+w\\/qv1o3cGm+hOtCT6Ey0\\/04l+xCBiAHw6SOeJ44jBELtJucTsHLH0kPfNEuQKuWkcMZUOv3LYVAafZW9LdaQ5wNNN+s00+CnwIlL2LYRotbIkwuzBOVx6IwAF+D2lAXThqWoKT2s7qNUFeMAz0x+ed+EgBuZ1OvSDA+0Wwsjmg4WgCJSAFWAtKAebwTZQDWrBfnAYNMEeewZcAJdBG7gDz5Mu8BT0gVdgAEEQEkJG1BFdxAgxR2wQR8QV8UL8kVAkCklAkpE0hI9IkHxkEVKCrELKkS1INbIPaUBOIOeQK8gtpBPpQf5G3qEYqoRqoAaoBToOdUXpaAgag05D09BZaB5aiC5Dy9BKtAatQ0+gF9A2tAN9ivZjAFPEtDBjzA5zxXyxcCwRS8WE2DysGCvFKrFa2ANasGtYB9aLvcWJuDpOxe1gFoPwWJyFz8Ln4UvxcnwnXoefwq\\/hnXgf\\/pFAJugTbAjuBAZhCiGNMJtQRCglVBEOEU7DDt1FeEUkErVgflxg3hKI6cQ5xKXEjcQ9xOPEK8SHxH4SiaRLsiF5ksJJTJKYVERaT6ohHSNdJXWR3sgpyhnJOcoFyCXK8eUK5Erldskdlbsq91huQF5F3lzeXT5cPkU+V365\\/Db5RvlL8l3yAwqqCpYKngoxCukKCxXKFGoVTivcVXihqKhoouimGKnIVVygWKa4V\\/GsYqfiWyU1JWslX6UkJYnSMqUdSseVbim9IJPJFmQfciJZTF5GriafJN8nv6GoU+wpDEoKZT6lglJHuUp5piyvbK5MV56unKdcqnxA+ZJyr4q8ioWKrwpTZZ5KhUqDyg2VflV1VQfVcNVM1aWqu1TPqXarkdQs1PzVUtQK1baqnVR7qI6pm6r7qrPUF6lvUz+t3qVB1LDUYGika5Ro\\/KJxUaNPU01zgmacZo5mheYRzQ4tTMtCi6HF01qutV+rXeudtoE2XZutvUS7Vvuq9mudMTo+OmydYp09Om0673Spuv66GbordQ\\/r3tPD9az1IvVm623SO63XO0ZjjMcY1pjiMfvH3NZH9a31o\\/Tn6G\\/Vb9XvNzA0CDQQGKw3OGnQa6hl6GOYbrjG8Khhj5G6kZcR12iN0TGjJ1RNKp3Ko5ZRT1H7jPWNg4wlxluMLxoPmFiaxJoUmOwxuWeqYOpqmmq6xrTZtM\\/MyGyyWb7ZbrPb5vLmruYc83XmLeavLSwt4i0WWxy26LbUsWRY5lnutrxrRbbytpplVWl1fSxxrOvYjLEbx162Rq2drDnWFdaXbFAbZxuuzUabK7YEWzdbvm2l7Q07JTu6XbbdbrtOey37UPsC+8P2z8aZjUsct3Jcy7iPNCcaD55udxzUHIIdChwaHf52tHZkOVY4Xh9PHh8wfv74+vHPJ9hMYE\\/YNOGmk7rTZKfFTs1OH5xdnIXOtc49LmYuyS4bXG64arhGuC51PetGcJvkNt+tye2tu7O72H2\\/+18edh4ZHrs8uidaTmRP3DbxoaeJJ9Nzi2eHF9Ur2etnrw5vY2+md6X3Ax9TnxSfKp\\/H9LH0dHoN\\/dkk2iThpEOTXvu6+871Pe6H+QX6Fftd9Ffzj\\/Uv978fYBKQFrA7oC\\/QKXBO4PEgQlBI0MqgGwwDBotRzegLdgmeG3wqRCkkOqQ85EGodagwtHEyOjl48urJd8PMw\\/hhh8NBOCN8dfi9CMuIWRG\\/RhIjIyIrIh9FOUTlR7VEq0fPiN4V\\/SpmUszymDuxVrGS2OY45bikuOq41\\/F+8aviO6aMmzJ3yoUEvQRuQn0iKTEusSqxf6r\\/1LVTu5KckoqS2qdZTsuZdm663nTe9CMzlGcwZxxIJiTHJ+9Kfs8MZ1Yy+2cyZm6Y2cfyZa1jPU3xSVmT0sP2ZK9iP071TF2V2p3mmbY6rYfjzSnl9HJ9ueXc5+lB6ZvTX2eEZ+zI+MSL5+3JlMtMzmzgq\\/Ez+KeyDLNysq4IbARFgo5Z7rPWzuoThgirRIhomqherAH\\/YLZKrCQ\\/SDqzvbIrst\\/Mjpt9IEc1h5\\/TmmuduyT3cV5A3vY5+BzWnOZ84\\/yF+Z1z6XO3zEPmzZzXPN90fuH8rgWBC3YuVFiYsfC3AlrBqoKXi+IXNRYaFC4ofPhD4A+7iyhFwqIbiz0Wb\\/4R\\/5H748Ul45esX\\/KxOKX4fAmtpLTk\\/VLW0vM\\/OfxU9tOnZanLLi53Xr5pBXEFf0X7Su+VO1eprspb9XD15NV1a6hrite8XDtj7bnSCaWb1ymsk6zrKAstq19vtn7F+vflnPK2ikkVezbob1iy4fXGlI1XN\\/lsqt1ssLlk87ufuT\\/f3BK4pa7SorJ0K3Fr9tZH2+K2tWx33V5dpVdVUvVhB39Hx86onaeqXaqrd+nvWr4b3S3Z3VOTVHP5F79f6mvtarfs0dpTshfslex9si95X\\/v+kP3NB1wP1B40P7jhkPqh4jqkLreu7zDncEd9Qv2VhuCG5kaPxkO\\/2v+6o8m4qeKI5pHlRxWOFh79dCzvWP9xwfHeE2knHjbPaL5zcsrJ66ciT108HXL67JmAMydb6C3HznqebTrnfq7hvOv5wxecL9S1OrUe+s3pt0MXnS\\/WXXK5VH\\/Z7XLjlYlXjl71vnrimt+1M9cZ1y+0hbVdaY9tv3kj6UbHzZSb3bd4t57fzr49cGcB\\/Igvvqdyr\\/S+\\/v3K38f+vqfDueNIp19n64PoB3cesh4+\\/UP0x\\/uuwkfkR6WPjR5Xdzt2N\\/UE9Fx+MvVJ11PB04Heoj9V\\/9zwzOrZwb98\\/mrtm9LX9Vz4\\/NPfS1\\/ovtjxcsLL5v6I\\/vuvMl8NvC5+o\\/tm51vXty3v4t89Hpj9nvS+7MPYD40fQz7e\\/ZT56dN\\/AC1d8BzqtvWAAAAAbGVYSWZNTQAqAAAACAAEARoABQAAAAEAAAA+ARsABQAAAAEAAABGASgAAwAAAAEAAgAAh2kABAAAAAEAAABOAAAAAAAAANgAAAABAAAA2AAAAAEAAqACAAQAAAABAAAAG6ADAAQAAAABAAAAMAAAAACUE0qCAAAACXBIWXMAACE4AAAhOAFFljFgAAAAHGlET1QAAAACAAAAAAAAABgAAAAoAAAAGAAAABgAAACcdH2CswAAAGhJREFUSA1iYCAF+DLMYehn0CRFCwNDJ8N\\/MPzGYEa8xi6oJpDWLcRqQ9b0n+EycdpQNf1nmEGMNnRNNxiECWvD1CQ5qgkUwTcYRgMCnN5HbEAsQ8ruRKeIUnI0MTDcRtF2h5i0x8AAAAAA\\/\\/+iFJ8yAAAAYElEQVRjYLjD8B8JPmCQZSAKVCBpAhlwl1iNK8jV2DCqEXfMjAYO7rBhGA0ckgJHEo9qJCn0UF2GJIeXiarxCV61KJLIGo+jyBDg1EOLjt8M7gRUokl7MSxgmMlgxsAAAPdReDyCV6t\\/AAAAAElFTkSuQmCC\"]"
        XCTAssert(encodedValue == expectedEncodedValue)

        let decoder = JSONDecoder()
        let decodedValues = try decoder.decode([ImageSourceType].self, from: data)

        for (index, value) in values.enumerated() {
            switch value {
                case .url:
                    XCTAssert(value == decodedValues[index])
                case .uiImage(let expectedImage):
                    if case .uiImage(let decodedImage) = decodedValues[index] {
                        // Double converting it to PNG so the conversion passes matches.
                        let expectedImageData = UIImage(data: expectedImage.pngData()!)!.pngData()!
                        let decodedImageData = decodedImage.pngData()!
                        XCTAssert(decodedImageData == expectedImageData)
                    } else {
                        XCTAssert(false, "Failed to convert UIImage to Data.")
                    }
            }
        }
    }
}
