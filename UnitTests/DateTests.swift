//
// Xcore
// Copyright © 2018 Xcore
// MIT license, see LICENSE file for details
//

import XCTest
import PromiseKit
@testable import Xcore

class DateTest: XCTestCase {
    override func setUp() {
        super.setUp()
        Date.configure(configuration: .default)
    }

    func testServerDate() {
        var date: Date?
        let syncExpectation = expectation(description: "sync_date")
        firstly {
            Date.syncServerDate(force: true)
        }.done {
            date = $0
            syncExpectation.fulfill()
        }.catch { error in
            syncExpectation.fulfill()
        }

        waitForExpectations(timeout: 60, handler: nil)
        XCTAssertEqual(Date.serverDate, date)
    }

    let customFormats: [Date.CustomFormat] = [
        .iso8601,
        .iso8601Local,
        .yearMonthDayDash,
        .yearMonthDash,
        .monthDaySlash,
        .year,
        .yearMonthDaySpace,
        .monthDayShortSpace,
        .monthDayYearFull,
        .monthDaySpace,
        .monthDayOrdinal,
        .monthShortPeriodDayOrdinal,
        .monthDayAbbreviated,
        .monthYearFull,
        .monthDayYearSlashTime,
        .yearMonthHash
    ]

    func testStringToDate() {
        for format in customFormats {
            let expectedDate: Date?
            let stringToTest: String
            switch format {
                case .iso8601:
                    stringToTest = "2020-04-04T11:11:22.000+0000"
                    expectedDate = Date(year: 2020, month: 4, day: 4, hour: 11, minute: 11, second: 22)
                case .iso8601Local:
                    stringToTest = "2020-06-04T11:11:22"
                    expectedDate = Date(year: 2020, month: 6, day: 4, hour: 11, minute: 11, second: 22)
                case .yearMonthDayDash:
                    stringToTest = "2020-06-04"
                    expectedDate = Date(year: 2020, month: 6, day: 4)
                case .yearMonthDash:
                    stringToTest = "2020-06"
                    expectedDate = Date(year: 2020, month: 6, day: 1)
                case .monthDaySlash:
                    stringToTest = "6/04"
                    expectedDate = Date(year: 2000, month: 6, day: 4)
                case .year:
                    stringToTest = "2020"
                    expectedDate = Date(year: 2020, month: 1, day: 1)
                case .yearMonthDaySpace:
                    stringToTest = "2020 06 04"
                    expectedDate = Date(year: 2020, month: 6, day: 4)
                case .monthDayShortSpace:
                    stringToTest = "Jun 04"
                    expectedDate = Date(year: 2000, month: 6, day: 4)
                case .monthDayYearFull:
                    stringToTest = "June 4, 2020"
                    expectedDate = Date(year: 2020, month: 6, day: 4)
                case .monthDaySpace:
                    stringToTest = "June 4"
                    expectedDate = Date(year: 2000, month: 6, day: 4)
                case .monthDayOrdinal:
                    stringToTest = ""
                    expectedDate = nil
                case .monthShortPeriodDayOrdinal:
                    stringToTest = ""
                    expectedDate = nil
                case .monthDayAbbreviated:
                    stringToTest = "Jun 4"
                    expectedDate = Date(year: 2000, month: 6, day: 4)
                case .monthYearFull:
                    stringToTest = "June 2020"
                    expectedDate = Date(year: 2020, month: 6, day: 1)
                case .monthDayYearSlashTime:
                    stringToTest = "06/04/2020 - 11:11AM"
                    expectedDate = Date(year: 2020, month: 6, day: 4, hour: 11, minute: 11)
                case .yearMonthHash:
                    stringToTest = "202006"
                    expectedDate = Date(year: 2020, month: 6, day: 1)
                default:
                    stringToTest = ""
                    expectedDate = Date()
                    XCTFail("Unknown format")
            }
            let date = Date(from: stringToTest, format: format)
            XCTAssertEqual(expectedDate, date)
        }
    }

    func testDateToCustomStringFormatInDefaultRegion() {
        let date = Date(year: 2020, month: 6, day: 4, hour: 11, minute: 11, second: 22)

        for format in customFormats {
            let expectedResult: String
            switch format {
                case .iso8601:
                    expectedResult = "2020-06-04T11:11:22.000+0000"
                case .iso8601Local:
                    expectedResult = "2020-06-04T11:11:22"
                case .yearMonthDayDash:
                    expectedResult = "2020-06-04"
                case .yearMonthDash:
                    expectedResult = "2020-06"
                case .monthDaySlash:
                    expectedResult = "6/04"
                case .year:
                    expectedResult = "2020"
                case .yearMonthDaySpace:
                    expectedResult = "2020 06 04"
                case .monthDayShortSpace:
                    expectedResult = "Jun 04"
                case .monthDayYearFull:
                    expectedResult = "June 4, 2020"
                case .monthDaySpace:
                    expectedResult = "June 4"
                case .monthDayOrdinal:
                    expectedResult = "June 4th"
                case .monthShortPeriodDayOrdinal:
                    expectedResult = "Jun. 4th"
                case .monthDayAbbreviated:
                    expectedResult = "Jun 4"
                case .monthYearFull:
                    expectedResult = "June 2020"
                case .monthDayYearSlashTime:
                    expectedResult = "06/04/2020 - 11:11AM"
                case .yearMonthHash:
                    expectedResult = "202006"
                default:
                    expectedResult = ""
                    XCTFail("Unknown format")
            }
            let dateString = date.toString(format: .custom(format))
            XCTAssertEqual(expectedResult, dateString)
        }
    }

    func testRelativeCalculation() {
        let date = Date()
        XCTAssertEqual("Today", date.toString(format: .date(.full), doesRelativeDateFormatting: true))
        let spanishRegion: Date.Region = .init(calendar: .gregorian, locale: Locale(identifier: "es"), timeZone: .utc)
        XCTAssertEqual("hoy", date.toString(format: .date(.full), doesRelativeDateFormatting: true, region: spanishRegion))
    }

    func testTimeInDifferentRegion() {
        let expectedHour = 17
        let date = Date(year: 2020, month: 5, day: 4, hour: 21, minute: 11, second: 22)
        let receivedHour = date.get(component: .hour, in: .usEastern)
        XCTAssertEqual(expectedHour, receivedHour)
    }

    func testDateAdjustments() {
        let expectedDate = Date(year: 2019, month: 9, day: 1, hour: 21, minute: 11, second: 22)
        let dateToAdjust = Date(year: 2020, month: 5, day: 4, hour: 21, minute: 11, second: 22)
        let adjustedDate = dateToAdjust
            .adjusting(.year, by: -1)
            .adjusting(.month, by: 4)
            .adjusting(.day, by: -3)
        XCTAssertEqual(expectedDate, adjustedDate)
    }

    func testBeginningOfDate() {
        let components: [Calendar.Component] = [.year, .month, .day, .hour, .minute]
        let dateToAdjust = Date(year: 2020, month: 5, day: 4, hour: 21, minute: 11, second: 22)
        for component in components {
            let expectedDate: Date
            switch component {
                case .year:
                    expectedDate = Date(year: 2020, month: 1, day: 1, hour: 0, minute: 0, second: 0)
                case .month:
                    expectedDate = Date(year: 2020, month: 5, day: 1, hour: 0, minute: 0, second: 0)
                case .day:
                    expectedDate = Date(year: 2020, month: 5, day: 4, hour: 0, minute: 0, second: 0)
                case .hour:
                    expectedDate = Date(year: 2020, month: 5, day: 4, hour: 21, minute: 0, second: 0)
                case .minute:
                    expectedDate = Date(year: 2020, month: 5, day: 4, hour: 21, minute: 11, second: 0)
                default:
                    expectedDate = Date()
                    XCTFail("Unsopported test case")
            }
            let beginningOfDate = dateToAdjust.dateAtStartOf(component: component)

            print("Expected Date = \(expectedDate)")
            print("Receieved Result = \(beginningOfDate)")
            XCTAssertEqual(expectedDate, beginningOfDate)
        }
    }

    func testEndOfDate() {
        let components: [Calendar.Component] = [.year, .month, .day, .hour, .minute]
        let dateToAdjust = Date(year: 2020, month: 5, day: 4, hour: 21, minute: 11, second: 22)
        for component in components {
            let expectedDate: Date
            switch component {
                case .year:
                    expectedDate = Date(year: 2020, month: 12, day: 31, hour: 23, minute: 59, second: 59).addingTimeInterval(0.999)
                case .month:
                    expectedDate = Date(year: 2020, month: 5, day: 31, hour: 23, minute: 59, second: 59).addingTimeInterval(0.999)
                case .day:
                    expectedDate = Date(year: 2020, month: 5, day: 4, hour: 23, minute: 59, second: 59).addingTimeInterval(0.999)
                case .hour:
                    expectedDate = Date(year: 2020, month: 5, day: 4, hour: 21, minute: 59, second: 59).addingTimeInterval(0.999)
                case .minute:
                    expectedDate = Date(year: 2020, month: 5, day: 4, hour: 21, minute: 11, second: 59).addingTimeInterval(0.999)
                default:
                    expectedDate = Date()
                    XCTFail("Unsopported test case")
            }
            let endOfDate = dateToAdjust.dateAtEndOf(component: component)

            XCTAssertEqual(expectedDate, endOfDate)
        }
    }

    func testMonthName() {
        let jan = Date(year: 2020, month: 1, day: 31, hour: 23, minute: 59, second: 59).monthName()
        let feb = Date(year: 2020, month: 2, day: 4, hour: 21, minute: 11, second: 22).monthName()
        let mar = Date(year: 2020, month: 3, day: 4, hour: 21, minute: 11, second: 22).monthName()
        let apr = Date(year: 2020, month: 4, day: 4, hour: 21, minute: 11, second: 22).monthName()
        let may = Date(year: 2020, month: 5, day: 4, hour: 21, minute: 11, second: 22).monthName()
        let jun = Date(year: 2020, month: 6, day: 4, hour: 21, minute: 11, second: 22).monthName()
        let jul = Date(year: 2020, month: 7, day: 4, hour: 21, minute: 11, second: 22).monthName()
        let aug = Date(year: 2020, month: 8, day: 4, hour: 21, minute: 11, second: 22).monthName()
        let sep = Date(year: 2020, month: 9, day: 4, hour: 21, minute: 11, second: 22).monthName()
        let oct = Date(year: 2020, month: 10, day: 4, hour: 21, minute: 11, second: 22).monthName()
        let nov = Date(year: 2020, month: 11, day: 4, hour: 21, minute: 11, second: 22).monthName()
        let dec = Date(year: 2020, month: 12, day: 4, hour: 21, minute: 11, second: 22).monthName()

        let spanishRegion: Date.Region = .init(calendar: .gregorian, locale: Locale(identifier: "es"), timeZone: .utc)
        let jan_es = Date(year: 2020, month: 1, day: 31, hour: 23, minute: 59, second: 59, region: spanishRegion).monthName(region: spanishRegion)
        let feb_es = Date(year: 2020, month: 2, day: 4, hour: 21, minute: 11, second: 22, region: spanishRegion).monthName(region: spanishRegion)
        let mar_es = Date(year: 2020, month: 3, day: 4, hour: 21, minute: 11, second: 22, region: spanishRegion).monthName(region: spanishRegion)
        let apr_es = Date(year: 2020, month: 4, day: 4, hour: 21, minute: 11, second: 22, region: spanishRegion).monthName(region: spanishRegion)
        let may_es = Date(year: 2020, month: 5, day: 4, hour: 21, minute: 11, second: 22, region: spanishRegion).monthName(region: spanishRegion)
        let jun_es = Date(year: 2020, month: 6, day: 4, hour: 21, minute: 11, second: 22, region: spanishRegion).monthName(region: spanishRegion)
        let jul_es = Date(year: 2020, month: 7, day: 4, hour: 21, minute: 11, second: 22, region: spanishRegion).monthName(region: spanishRegion)
        let aug_es = Date(year: 2020, month: 8, day: 4, hour: 21, minute: 11, second: 22, region: spanishRegion).monthName(region: spanishRegion)
        let sep_es = Date(year: 2020, month: 9, day: 4, hour: 21, minute: 11, second: 22, region: spanishRegion).monthName(region: spanishRegion)
        let oct_es = Date(year: 2020, month: 10, day: 4, hour: 21, minute: 11, second: 22, region: spanishRegion).monthName(region: spanishRegion)
        let nov_es = Date(year: 2020, month: 11, day: 4, hour: 21, minute: 11, second: 22, region: spanishRegion).monthName(region: spanishRegion)
        let dec_es = Date(year: 2020, month: 12, day: 4, hour: 21, minute: 11, second: 22, region: spanishRegion).monthName(region: spanishRegion)

        XCTAssertEqual(jan, "January")
        XCTAssertEqual(feb, "February")
        XCTAssertEqual(mar, "March")
        XCTAssertEqual(apr, "April")
        XCTAssertEqual(may, "May")
        XCTAssertEqual(jun, "June")
        XCTAssertEqual(jul, "July")
        XCTAssertEqual(aug, "August")
        XCTAssertEqual(sep, "September")
        XCTAssertEqual(oct, "October")
        XCTAssertEqual(nov, "November")
        XCTAssertEqual(dec, "December")

        XCTAssertEqual(jan_es, "enero")
        XCTAssertEqual(feb_es, "febrero")
        XCTAssertEqual(mar_es, "marzo")
        XCTAssertEqual(apr_es, "abril")
        XCTAssertEqual(may_es, "mayo")
        XCTAssertEqual(jun_es, "junio")
        XCTAssertEqual(jul_es, "julio")
        XCTAssertEqual(aug_es, "agosto")
        XCTAssertEqual(sep_es, "septiembre")
        XCTAssertEqual(oct_es, "octubre")
        XCTAssertEqual(nov_es, "noviembre")
        XCTAssertEqual(dec_es, "diciembre")
    }

    func testWeekName() {
        let mon = Date(year: 2020, month: 1, day: 6, hour: 23, minute: 59, second: 59).weekdayName()
        let tue = Date(year: 2020, month: 1, day: 7, hour: 23, minute: 59, second: 59).weekdayName()
        let wed = Date(year: 2020, month: 1, day: 8, hour: 23, minute: 59, second: 59).weekdayName()
        let thu = Date(year: 2020, month: 1, day: 9, hour: 23, minute: 59, second: 59).weekdayName()
        let fri = Date(year: 2020, month: 1, day: 10, hour: 23, minute: 59, second: 59).weekdayName()
        let sat = Date(year: 2020, month: 1, day: 11, hour: 23, minute: 59, second: 59).weekdayName()
        let sun = Date(year: 2020, month: 1, day: 12, hour: 23, minute: 59, second: 59).weekdayName()

        let spanishRegion: Date.Region = .init(calendar: .gregorian, locale: Locale(identifier: "es"), timeZone: .utc)

        let mon_es = Date(year: 2020, month: 1, day: 6, hour: 23, minute: 59, second: 59, region: spanishRegion).weekdayName(region: spanishRegion)
        let tue_es = Date(year: 2020, month: 1, day: 7, hour: 23, minute: 59, second: 59, region: spanishRegion).weekdayName(region: spanishRegion)
        let wed_es = Date(year: 2020, month: 1, day: 8, hour: 23, minute: 59, second: 59, region: spanishRegion).weekdayName(region: spanishRegion)
        let thu_es = Date(year: 2020, month: 1, day: 9, hour: 23, minute: 59, second: 59, region: spanishRegion).weekdayName(region: spanishRegion)
        let fri_es = Date(year: 2020, month: 1, day: 10, hour: 23, minute: 59, second: 59, region: spanishRegion).weekdayName(region: spanishRegion)
        let sat_es = Date(year: 2020, month: 1, day: 11, hour: 23, minute: 59, second: 59, region: spanishRegion).weekdayName(region: spanishRegion)
        let sun_es = Date(year: 2020, month: 1, day: 12, hour: 23, minute: 59, second: 59, region: spanishRegion).weekdayName(region: spanishRegion)

        XCTAssertEqual(mon, "Monday")
        XCTAssertEqual(tue, "Tuesday")
        XCTAssertEqual(wed, "Wednesday")
        XCTAssertEqual(thu, "Thursday")
        XCTAssertEqual(fri, "Friday")
        XCTAssertEqual(sat, "Saturday")
        XCTAssertEqual(sun, "Sunday")

        XCTAssertEqual(mon_es, "lunes")
        XCTAssertEqual(tue_es, "martes")
        XCTAssertEqual(wed_es, "miércoles")
        XCTAssertEqual(thu_es, "jueves")
        XCTAssertEqual(fri_es, "viernes")
        XCTAssertEqual(sat_es, "sábado")
        XCTAssertEqual(sun_es, "domingo")
    }

    func testWeekNameFromIndex() {
        XCTAssertEqual(Date.weekdayName(for: 0), "Sunday")
        XCTAssertEqual(Date.weekdayName(for: 1), "Monday")
        XCTAssertEqual(Date.weekdayName(for: 2), "Tuesday")
        XCTAssertEqual(Date.weekdayName(for: 3), "Wednesday")
        XCTAssertEqual(Date.weekdayName(for: 4), "Thursday")
        XCTAssertEqual(Date.weekdayName(for: 5), "Friday")
        XCTAssertEqual(Date.weekdayName(for: 6), "Saturday")

        let spanishRegion: Date.Region = .init(calendar: .gregorian, locale: Locale(identifier: "es"), timeZone: .utc)
        XCTAssertEqual(Date.weekdayName(for: 0, region: spanishRegion), "domingo")
        XCTAssertEqual(Date.weekdayName(for: 1, region: spanishRegion), "lunes")
        XCTAssertEqual(Date.weekdayName(for: 2, region: spanishRegion), "martes")
        XCTAssertEqual(Date.weekdayName(for: 3, region: spanishRegion), "miércoles")
        XCTAssertEqual(Date.weekdayName(for: 4, region: spanishRegion), "jueves")
        XCTAssertEqual(Date.weekdayName(for: 5, region: spanishRegion), "viernes")
        XCTAssertEqual(Date.weekdayName(for: 6, region: spanishRegion), "sábado")
    }

    func testDateUnit() {
        let date = Date(year: 2020, month: 2, day: 1, hour: 3, minute: 41, second: 22)

        XCTAssertEqual(2020, date.get(component: .year))
        XCTAssertEqual(2, date.get(component: .month))
        XCTAssertEqual(1, date.get(component: .day))
        XCTAssertEqual(3, date.get(component: .hour))
        XCTAssertEqual(41, date.get(component: .minute))
        XCTAssertEqual(22, date.get(component: .second))

        // Test in different region.
        XCTAssertEqual(2020, date.get(component: .year, in: .usEastern))
        XCTAssertEqual(1, date.get(component: .month, in: .usEastern))
        XCTAssertEqual(31, date.get(component: .day, in: .usEastern))
        XCTAssertEqual(22, date.get(component: .hour, in: .usEastern))
        XCTAssertEqual(41, date.get(component: .minute, in: .usEastern))
        XCTAssertEqual(22, date.get(component: .second, in: .usEastern))
    }

    func testIsSameDate() {
        let testYearGranularityDateLeft = Date(year: 2020, month: 4, day: 5, hour: 1, minute: 45, second: 33)
        let testYearGranularityDateRight = Date(year: 2020, month: 2, day: 1, hour: 3, minute: 41, second: 22)

        let testMonthGranularityDateLeft = Date(year: 2020, month: 4, day: 5, hour: 1, minute: 45, second: 33)
        let testMonthGranularityDateRight = Date(year: 2020, month: 4, day: 1, hour: 3, minute: 41, second: 22)

        let testDayGranularityDateLeft = Date(year: 2020, month: 4, day: 5, hour: 1, minute: 45, second: 33)
        let testDayGranularityDateRight = Date(year: 2020, month: 4, day: 5, hour: 3, minute: 41, second: 22)

        let testHourGranularityDateLeft = Date(year: 2020, month: 4, day: 5, hour: 1, minute: 45, second: 33)
        let testHourGranularityDateRight = Date(year: 2020, month: 4, day: 5, hour: 1, minute: 41, second: 22)

        let testMinuteGranularityDateLeft = Date(year: 2020, month: 4, day: 5, hour: 1, minute: 45, second: 33)
        let testMinuteGranularityDateRight = Date(year: 2020, month: 4, day: 5, hour: 1, minute: 45, second: 22)

        let testSecondsGranularityDateLeft = Date(year: 2020, month: 4, day: 5, hour: 1, minute: 45, second: 33)
        let testSecondsGranularityDateRight = Date(year: 2020, month: 4, day: 5, hour: 1, minute: 45, second: 33)

        let testMultipleRegionDateLeft = Date(year: 2020, month: 4, day: 5, hour: 1, minute: 45, second: 33, region: .ISO)
        let testMultipleRegionDateRight = Date(year: 2020, month: 4, day: 4, hour: 21, minute: 45, second: 33, region: .usEastern)

        XCTAssert(testYearGranularityDateLeft.isSame(date: testYearGranularityDateRight, granularity: .year), "Year granularity failed")
        XCTAssert(testMonthGranularityDateLeft.isSame(date: testMonthGranularityDateRight, granularity: .month), "Month granularity failed")
        XCTAssert(testDayGranularityDateLeft.isSame(date: testDayGranularityDateRight, granularity: .day), "Day granularity failed")
        XCTAssert(testHourGranularityDateLeft.isSame(date: testHourGranularityDateRight, granularity: .hour), "Hour granularity failed")
        XCTAssert(testMinuteGranularityDateLeft.isSame(date: testMinuteGranularityDateRight, granularity: .minute), "Minute granularity failed")
        XCTAssert(testSecondsGranularityDateLeft.isSame(date: testSecondsGranularityDateRight, granularity: .second), "Seconds granularity failed")
        XCTAssert(testSecondsGranularityDateLeft.isSame(date: testSecondsGranularityDateRight, granularity: .nanosecond), "NanoSeconds granularity failed")
        XCTAssert(testMultipleRegionDateLeft.isSame(date: testMultipleRegionDateRight, granularity: .second), "Multi region test failed")
    }

    func testIsPastDate() {
        let testYearGranularityDateLeft = Date(year: 2019, month: 4, day: 5, hour: 1, minute: 45, second: 33)
        let testYearGranularityDateRight = Date(year: 2020, month: 2, day: 1, hour: 3, minute: 41, second: 22)

        let testMonthGranularityDateLeft = Date(year: 2020, month: 3, day: 5, hour: 1, minute: 45, second: 33)
        let testMonthGranularityDateRight = Date(year: 2020, month: 4, day: 1, hour: 3, minute: 41, second: 22)

        let testDayGranularityDateLeft = Date(year: 2020, month: 4, day: 3, hour: 1, minute: 45, second: 33)
        let testDayGranularityDateRight = Date(year: 2020, month: 4, day: 5, hour: 3, minute: 41, second: 22)

        let testHourGranularityDateLeft = Date(year: 2020, month: 4, day: 5, hour: 0, minute: 45, second: 33)
        let testHourGranularityDateRight = Date(year: 2020, month: 4, day: 5, hour: 1, minute: 41, second: 22)

        let testMinuteGranularityDateLeft = Date(year: 2020, month: 4, day: 5, hour: 1, minute: 44, second: 33)
        let testMinuteGranularityDateRight = Date(year: 2020, month: 4, day: 5, hour: 1, minute: 45, second: 22)

        let testSecondsGranularityDateLeft = Date(year: 2020, month: 4, day: 5, hour: 1, minute: 45, second: 11)
        let testSecondsGranularityDateRight = Date(year: 2020, month: 4, day: 5, hour: 1, minute: 45, second: 33)

        let testMultipleRegionDateLeft = Date(year: 2020, month: 4, day: 5, hour: 1, minute: 45, second: 33, region: .ISO)
        let testMultipleRegionDateRight = Date(year: 2020, month: 4, day: 4, hour: 21, minute: 46, second: 33, region: .usEastern)

        XCTAssert(testYearGranularityDateLeft.isBefore(date: testYearGranularityDateRight, granularity: .year), "Year granularity failed")
        XCTAssert(testMonthGranularityDateLeft.isBefore(date: testMonthGranularityDateRight, granularity: .month), "Month granularity failed")
        XCTAssert(testDayGranularityDateLeft.isBefore(date: testDayGranularityDateRight, granularity: .day), "Day granularity failed")
        XCTAssert(testHourGranularityDateLeft.isBefore(date: testHourGranularityDateRight, granularity: .hour), "Hour granularity failed")
        XCTAssert(testMinuteGranularityDateLeft.isBefore(date: testMinuteGranularityDateRight, granularity: .minute), "Minute granularity failed")
        XCTAssert(testSecondsGranularityDateLeft.isBefore(date: testSecondsGranularityDateRight, granularity: .second), "Seconds granularity failed")
        XCTAssert(testSecondsGranularityDateLeft.isBefore(date: testSecondsGranularityDateRight, granularity: .nanosecond), "NanoSeconds granularity failed")
        XCTAssert(testMultipleRegionDateLeft.isBefore(date: testMultipleRegionDateRight, granularity: .second), "Multi region test failed")
    }

    func testIsFutureDate() {
        let testYearGranularityDateLeft = Date(year: 2021, month: 4, day: 5, hour: 1, minute: 45, second: 33)
        let testYearGranularityDateRight = Date(year: 2020, month: 2, day: 1, hour: 3, minute: 41, second: 22)

        let testMonthGranularityDateLeft = Date(year: 2020, month: 5, day: 5, hour: 1, minute: 45, second: 33)
        let testMonthGranularityDateRight = Date(year: 2020, month: 4, day: 1, hour: 3, minute: 41, second: 22)

        let testDayGranularityDateLeft = Date(year: 2020, month: 4, day: 6, hour: 1, minute: 45, second: 33)
        let testDayGranularityDateRight = Date(year: 2020, month: 4, day: 5, hour: 3, minute: 41, second: 22)

        let testHourGranularityDateLeft = Date(year: 2020, month: 4, day: 5, hour: 2, minute: 45, second: 33)
        let testHourGranularityDateRight = Date(year: 2020, month: 4, day: 5, hour: 1, minute: 41, second: 22)

        let testMinuteGranularityDateLeft = Date(year: 2020, month: 4, day: 5, hour: 1, minute: 55, second: 33)
        let testMinuteGranularityDateRight = Date(year: 2020, month: 4, day: 5, hour: 1, minute: 45, second: 22)

        let testSecondsGranularityDateLeft = Date(year: 2020, month: 4, day: 5, hour: 1, minute: 45, second: 44)
        let testSecondsGranularityDateRight = Date(year: 2020, month: 4, day: 5, hour: 1, minute: 45, second: 33)

        let testMultipleRegionDateLeft = Date(year: 2020, month: 4, day: 5, hour: 1, minute: 47, second: 33, region: .ISO)
        let testMultipleRegionDateRight = Date(year: 2020, month: 4, day: 4, hour: 21, minute: 46, second: 33, region: .usEastern)

        XCTAssert(testYearGranularityDateLeft.isAfter(date: testYearGranularityDateRight, granularity: .year), "Year granularity failed")
        XCTAssert(testMonthGranularityDateLeft.isAfter(date: testMonthGranularityDateRight, granularity: .month), "Month granularity failed")
        XCTAssert(testDayGranularityDateLeft.isAfter(date: testDayGranularityDateRight, granularity: .day), "Day granularity failed")
        XCTAssert(testHourGranularityDateLeft.isAfter(date: testHourGranularityDateRight, granularity: .hour), "Hour granularity failed")
        XCTAssert(testMinuteGranularityDateLeft.isAfter(date: testMinuteGranularityDateRight, granularity: .minute), "Minute granularity failed")
        XCTAssert(testSecondsGranularityDateLeft.isAfter(date: testSecondsGranularityDateRight, granularity: .second), "Seconds granularity failed")
        XCTAssert(testSecondsGranularityDateLeft.isAfter(date: testSecondsGranularityDateRight, granularity: .nanosecond), "NanoSeconds granularity failed")
        XCTAssert(testMultipleRegionDateLeft.isAfter(date: testMultipleRegionDateRight, granularity: .second), "Multi region test failed")
    }

    func testIsBetweenDate() {
        let testYearGranularityDateLeft = Date(year: 2021, month: 4, day: 5, hour: 1, minute: 45, second: 33)
        let testYearGranularityDateMid = Date(year: 2020, month: 4, day: 5, hour: 1, minute: 45, second: 33)
        let testYearGranularityDateRight = Date(year: 2019, month: 2, day: 1, hour: 3, minute: 41, second: 22)

        let testMonthGranularityDateLeft = Date(year: 2020, month: 6, day: 5, hour: 1, minute: 45, second: 33)
        let testMonthGranularityDatemid = Date(year: 2020, month: 5, day: 5, hour: 1, minute: 45, second: 33)
        let testMonthGranularityDateRight = Date(year: 2020, month: 4, day: 1, hour: 3, minute: 41, second: 22)

        let testDayGranularityDateLeft = Date(year: 2020, month: 4, day: 7, hour: 1, minute: 45, second: 33)
        let testDayGranularityDateMid = Date(year: 2020, month: 4, day: 6, hour: 1, minute: 45, second: 33)
        let testDayGranularityDateRight = Date(year: 2020, month: 4, day: 5, hour: 3, minute: 41, second: 22)

        let testHourGranularityDateLeft = Date(year: 2020, month: 4, day: 5, hour: 3, minute: 45, second: 33)
        let testHourGranularityDateMid = Date(year: 2020, month: 4, day: 5, hour: 2, minute: 45, second: 33)
        let testHourGranularityDateRight = Date(year: 2020, month: 4, day: 5, hour: 1, minute: 41, second: 22)

        let testMinuteGranularityDateLeft = Date(year: 2020, month: 4, day: 5, hour: 1, minute: 59, second: 33)
        let testMinuteGranularityDateMid = Date(year: 2020, month: 4, day: 5, hour: 1, minute: 55, second: 33)
        let testMinuteGranularityDateRight = Date(year: 2020, month: 4, day: 5, hour: 1, minute: 45, second: 22)

        let testSecondsGranularityDateLeft = Date(year: 2020, month: 4, day: 5, hour: 1, minute: 45, second: 55)
        let testSecondsGranularityDateMid = Date(year: 2020, month: 4, day: 5, hour: 1, minute: 45, second: 44)
        let testSecondsGranularityDateRight = Date(year: 2020, month: 4, day: 5, hour: 1, minute: 45, second: 33)

        let testMultipleRegionDateLeft = Date(year: 2020, month: 4, day: 5, hour: 1, minute: 47, second: 33, region: .ISO)
        let testMultipleRegionDateMid = Date(year: 2020, month: 4, day: 5, hour: 4, minute: 36, second: 33, region: .init(calendar: .gregorian, locale: Locale(identifier: "TR"), timeZone: TimeZone(identifier: "Europe/Istanbul")!))
        let testMultipleRegionDateRight = Date(year: 2020, month: 4, day: 4, hour: 21, minute: 30, second: 33, region: .usEastern)

        XCTAssert(testYearGranularityDateMid.isInBetween(date: testYearGranularityDateRight, and: testYearGranularityDateLeft, granularity: .year), "Year granularity failed")
        XCTAssert(testMonthGranularityDatemid.isInBetween(date: testMonthGranularityDateRight, and: testMonthGranularityDateLeft, granularity: .month), "Month granularity failed")
        XCTAssert(testDayGranularityDateMid.isInBetween(date: testDayGranularityDateRight, and: testDayGranularityDateLeft, granularity: .day), "Day granularity failed")
        XCTAssert(testHourGranularityDateMid.isInBetween(date: testHourGranularityDateRight, and: testHourGranularityDateLeft, granularity: .hour), "Hour granularity failed")
        XCTAssert(testMinuteGranularityDateMid.isInBetween(date: testMinuteGranularityDateRight, and: testMinuteGranularityDateLeft, granularity: .minute), "Minute granularity failed")
        XCTAssert(testSecondsGranularityDateMid.isInBetween(date: testSecondsGranularityDateRight, and: testSecondsGranularityDateLeft, granularity: .second), "Seconds granularity failed")
        XCTAssert(testSecondsGranularityDateMid.isInBetween(date: testSecondsGranularityDateRight, and: testSecondsGranularityDateLeft, granularity: .nanosecond), "NanoSeconds granularity failed")
        XCTAssert(testMultipleRegionDateMid.isInBetween(date: testMultipleRegionDateRight, and: testMultipleRegionDateLeft, granularity: .second), "Multi region test failed")
    }

    func testUntilDate() {
        let date = Date(year: 2019, month: 3, day: 4, hour: 2, minute: 22, second: 44)
        let untilDate = Date(year: 2020, month: 4, day: 5, hour: 1, minute: 45, second: 55)
        XCTAssertEqual(1, date.numberOf(.year, until: untilDate))
        XCTAssertEqual(13, date.numberOf(.month, until: untilDate))
        XCTAssertEqual(398, date.numberOf(.day, until: untilDate))
        XCTAssertEqual(9551, date.numberOf(.hour, until: untilDate))
        XCTAssertEqual(573083, date.numberOf(.minute, until: untilDate))
        XCTAssertEqual(34384991, date.numberOf(.second, until: untilDate))
    }

    func testTimeZone() {
        XCTAssertEqual(Date.timeZoneOffset(region: .usEastern), -4)
        XCTAssertEqual(Date.timeZoneOffset(region: .ISO), 0)
        XCTAssertEqual(Date.timeZoneOffset(region: .init(calendar: .gregorian, locale: Locale(identifier: "TR"), timeZone: TimeZone(identifier: "Europe/Istanbul")!)), 3)
    }

    func testTotalDayInCurrentMonth() {
        let jan = Date(year: 2020, month: 1, day: 1, hour: 3, minute: 41, second: 22)
        let leapYearFeb = Date(year: 2020, month: 2, day: 1, hour: 3, minute: 41, second: 22)
        let nonLeapYearFeb = Date(year: 2019, month: 2, day: 1, hour: 3, minute: 41, second: 22)
        let mar = Date(year: 2020, month: 3, day: 1, hour: 3, minute: 41, second: 22)
        let apr = Date(year: 2020, month: 4, day: 1, hour: 3, minute: 41, second: 22)
        let may = Date(year: 2020, month: 5, day: 1, hour: 3, minute: 41, second: 22)
        let jun = Date(year: 2020, month: 6, day: 1, hour: 3, minute: 41, second: 22)
        let jul = Date(year: 2020, month: 7, day: 1, hour: 3, minute: 41, second: 22)
        let aug = Date(year: 2020, month: 8, day: 1, hour: 3, minute: 41, second: 22)
        let sep = Date(year: 2020, month: 9, day: 1, hour: 3, minute: 41, second: 22)
        let oct = Date(year: 2020, month: 10, day: 1, hour: 3, minute: 41, second: 22)
        let nov = Date(year: 2020, month: 11, day: 1, hour: 3, minute: 41, second: 22)
        let dec = Date(year: 2020, month: 12, day: 1, hour: 3, minute: 41, second: 22)

        XCTAssertEqual(jan.totalDaysInCurrentMonth, 31)
        XCTAssertEqual(leapYearFeb.totalDaysInCurrentMonth, 29)
        XCTAssertEqual(nonLeapYearFeb.totalDaysInCurrentMonth, 28)
        XCTAssertEqual(mar.totalDaysInCurrentMonth, 31)
        XCTAssertEqual(apr.totalDaysInCurrentMonth, 30)
        XCTAssertEqual(may.totalDaysInCurrentMonth, 31)
        XCTAssertEqual(jun.totalDaysInCurrentMonth, 30)
        XCTAssertEqual(jul.totalDaysInCurrentMonth, 31)
        XCTAssertEqual(aug.totalDaysInCurrentMonth, 31)
        XCTAssertEqual(sep.totalDaysInCurrentMonth, 30)
        XCTAssertEqual(oct.totalDaysInCurrentMonth, 31)
        XCTAssertEqual(nov.totalDaysInCurrentMonth, 30)
        XCTAssertEqual(dec.totalDaysInCurrentMonth, 31)
    }

    func testAdjustmentWithDateComponents() {
        let dateToAdjust = Date(year: 2020, month: 3, day: 1, hour: 3, minute: 41, second: 22)
        var dateComponents = DateComponents()
        dateComponents.year = 1
        dateComponents.month = -2
        dateComponents.day = 3

        let expectedResult = Date(year: 2021, month: 1, day: 4, hour: 3, minute: 41, second: 22)
        XCTAssertEqual(expectedResult, dateToAdjust.adjusting(components: dateComponents))
    }
}

extension Date.Configuration {
    static var `default`: Self {
        .init(
            region: .gregorianUtc,
            serverDateProvider: serverDateProvider,
            serverDateExpirationTime: 36000
        )
    }

    private static var serverDateProvider: Promise<Date> {
        .init { seal in
            after(seconds: 1).then {
                Promise.value("2020-04-19")
            }.done { rawServerDate in
                guard let date = Date(from: rawServerDate, format: .yearMonthDayDash) else {
                    throw ParsingError()
                }
                seal.fulfill(date)
            }.catch { error in
                seal.reject(error)
            }
        }
    }
}

private struct ParsingError: Error {}
