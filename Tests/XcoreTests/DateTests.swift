//
// Xcore
// Copyright © 2018 Xcore
// MIT license, see LICENSE file for details
//

import XCTest
@testable import Xcore

final class DateTest: XCTestCase {
    override func setUp() {
        super.setUp()
        Calendar.default = .iso
    }

    private let customFormats: [Date.Format.Custom] = [
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
        .monthShortDayOrdinal,
        .monthShortPeriodDayOrdinal,
        .monthDayAbbreviated,
        .monthYearFull,
        .monthDayYearSlashTime
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
                case .monthDayOrdinal,
                     .monthShortDayOrdinal,
                     .monthShortPeriodDayOrdinal:
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
                default:
                    stringToTest = ""
                    expectedDate = Date()
                    XCTFail("Unknown format")
            }
            let date = Date(from: stringToTest, format: format)
            XCTAssertEqual(expectedDate, date)
        }
    }

    func testDateToCustomStringFormatInDefaultCalendar() {
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
                case .monthShortDayOrdinal:
                    expectedResult = "Jun 4th"
                case .monthShortPeriodDayOrdinal:
                    expectedResult = "Jun. 4th"
                case .monthDayAbbreviated:
                    expectedResult = "Jun 4"
                case .monthYearFull:
                    expectedResult = "June 2020"
                case .monthDayYearSlashTime:
                    expectedResult = "06/04/2020 - 11:11AM"
                default:
                    expectedResult = ""
                    XCTFail("Unknown format")
            }

            let dateString = date.string(format: .custom(format))
            XCTAssertEqual(expectedResult, dateString, "\(format) format \(dateString) is not equal to \(expectedResult)")
        }
    }

    func testDateToMonthShortPeriodDayOrdinalPeriod() {
        // Test that May abbreviation should not contain period (e.g., May 3rd).
        let mayDate = Date(year: 2020, month: 5, day: 3, hour: 11, minute: 11, second: 22)
        let mayExpectedResult = "May 3rd" // Shouldn't contain period after May
        let mayResult = mayDate.string(format: .custom(.monthShortPeriodDayOrdinal))
        XCTAssertEqual(mayExpectedResult, mayResult)

        // Test that June abbreviation should contain period (e.g., Jun. 4th).
        let juneDate = Date(year: 2020, month: 6, day: 4, hour: 11, minute: 11, second: 22)
        let juneExpectedResult = "Jun. 4th" // Should contain period after Jun.
        let juneResult = juneDate.string(format: .custom(.monthShortPeriodDayOrdinal))
        XCTAssertEqual(juneExpectedResult, juneResult)
    }

    func testRelativeCalculation() {
        let date = Date()
        XCTAssertEqual("Today", date.string(format: .date(.full), doesRelativeDateFormatting: true))
        XCTAssertEqual("hoy", date.string(format: .date(.full), doesRelativeDateFormatting: true, in: .spanish))
    }

    func testTimeInDifferentCalendar() {
        let expectedHour = 17
        let date = Date(year: 2020, month: 5, day: 4, hour: 21, minute: 11, second: 22)
        let receivedHour = date.component(.hour, in: .usEastern)
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

    func testStartOfDate() {
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

            let startOfDate = dateToAdjust.startOf(component)
            print("Expected Date = \(expectedDate)")
            print("Receieved Result = \(startOfDate)")
            XCTAssertEqual(expectedDate, startOfDate)
        }
    }

    func testStartOfDate_Calendar() {
        let expectedDate = Date(year: 2020, month: 1, day: 1, calendar: .current)
        let adjustedDate = expectedDate.startOf(.month, in: .current)
        XCTAssertEqual(expectedDate, adjustedDate)
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

            let endOfDate = dateToAdjust.endOf(component)
            XCTAssertEqual(expectedDate, endOfDate)
        }
    }

    func testMonthName() {
        let jan = Date(year: 2020, month: 1, day: 31, hour: 23, minute: 59, second: 59).string(format: .monthName)
        let feb = Date(year: 2020, month: 2, day: 4, hour: 21, minute: 11, second: 22).string(format: .monthName)
        let mar = Date(year: 2020, month: 3, day: 4, hour: 21, minute: 11, second: 22).string(format: .monthName)
        let apr = Date(year: 2020, month: 4, day: 4, hour: 21, minute: 11, second: 22).string(format: .monthName)
        let may = Date(year: 2020, month: 5, day: 4, hour: 21, minute: 11, second: 22).string(format: .monthName)
        let jun = Date(year: 2020, month: 6, day: 4, hour: 21, minute: 11, second: 22).string(format: .monthName)
        let jul = Date(year: 2020, month: 7, day: 4, hour: 21, minute: 11, second: 22).string(format: .monthName)
        let aug = Date(year: 2020, month: 8, day: 4, hour: 21, minute: 11, second: 22).string(format: .monthName)
        let sep = Date(year: 2020, month: 9, day: 4, hour: 21, minute: 11, second: 22).string(format: .monthName)
        let oct = Date(year: 2020, month: 10, day: 4, hour: 21, minute: 11, second: 22).string(format: .monthName)
        let nov = Date(year: 2020, month: 11, day: 4, hour: 21, minute: 11, second: 22).string(format: .monthName)
        let dec = Date(year: 2020, month: 12, day: 4, hour: 21, minute: 11, second: 22).string(format: .monthName)

        let jan_es = Date(year: 2020, month: 1, day: 31, hour: 23, minute: 59, second: 59, calendar: .spanish).string(format: .monthName, in: .spanish)
        let feb_es = Date(year: 2020, month: 2, day: 4, hour: 21, minute: 11, second: 22, calendar: .spanish).string(format: .monthName, in: .spanish)
        let mar_es = Date(year: 2020, month: 3, day: 4, hour: 21, minute: 11, second: 22, calendar: .spanish).string(format: .monthName, in: .spanish)
        let apr_es = Date(year: 2020, month: 4, day: 4, hour: 21, minute: 11, second: 22, calendar: .spanish).string(format: .monthName, in: .spanish)
        let may_es = Date(year: 2020, month: 5, day: 4, hour: 21, minute: 11, second: 22, calendar: .spanish).string(format: .monthName, in: .spanish)
        let jun_es = Date(year: 2020, month: 6, day: 4, hour: 21, minute: 11, second: 22, calendar: .spanish).string(format: .monthName, in: .spanish)
        let jul_es = Date(year: 2020, month: 7, day: 4, hour: 21, minute: 11, second: 22, calendar: .spanish).string(format: .monthName, in: .spanish)
        let aug_es = Date(year: 2020, month: 8, day: 4, hour: 21, minute: 11, second: 22, calendar: .spanish).string(format: .monthName, in: .spanish)
        let sep_es = Date(year: 2020, month: 9, day: 4, hour: 21, minute: 11, second: 22, calendar: .spanish).string(format: .monthName, in: .spanish)
        let oct_es = Date(year: 2020, month: 10, day: 4, hour: 21, minute: 11, second: 22, calendar: .spanish).string(format: .monthName, in: .spanish)
        let nov_es = Date(year: 2020, month: 11, day: 4, hour: 21, minute: 11, second: 22, calendar: .spanish).string(format: .monthName, in: .spanish)
        let dec_es = Date(year: 2020, month: 12, day: 4, hour: 21, minute: 11, second: 22, calendar: .spanish).string(format: .monthName, in: .spanish)

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
        let mon = Date(year: 2020, month: 1, day: 6, hour: 23, minute: 59, second: 59).string(format: .weekdayName)
        let tue = Date(year: 2020, month: 1, day: 7, hour: 23, minute: 59, second: 59).string(format: .weekdayName)
        let wed = Date(year: 2020, month: 1, day: 8, hour: 23, minute: 59, second: 59).string(format: .weekdayName)
        let thu = Date(year: 2020, month: 1, day: 9, hour: 23, minute: 59, second: 59).string(format: .weekdayName)
        let fri = Date(year: 2020, month: 1, day: 10, hour: 23, minute: 59, second: 59).string(format: .weekdayName)
        let sat = Date(year: 2020, month: 1, day: 11, hour: 23, minute: 59, second: 59).string(format: .weekdayName)
        let sun = Date(year: 2020, month: 1, day: 12, hour: 23, minute: 59, second: 59).string(format: .weekdayName)

        let mon_es = Date(year: 2020, month: 1, day: 6, hour: 23, minute: 59, second: 59, calendar: .spanish).string(format: .weekdayName, in: .spanish)
        let tue_es = Date(year: 2020, month: 1, day: 7, hour: 23, minute: 59, second: 59, calendar: .spanish).string(format: .weekdayName, in: .spanish)
        let wed_es = Date(year: 2020, month: 1, day: 8, hour: 23, minute: 59, second: 59, calendar: .spanish).string(format: .weekdayName, in: .spanish)
        let thu_es = Date(year: 2020, month: 1, day: 9, hour: 23, minute: 59, second: 59, calendar: .spanish).string(format: .weekdayName, in: .spanish)
        let fri_es = Date(year: 2020, month: 1, day: 10, hour: 23, minute: 59, second: 59, calendar: .spanish).string(format: .weekdayName, in: .spanish)
        let sat_es = Date(year: 2020, month: 1, day: 11, hour: 23, minute: 59, second: 59, calendar: .spanish).string(format: .weekdayName, in: .spanish)
        let sun_es = Date(year: 2020, month: 1, day: 12, hour: 23, minute: 59, second: 59, calendar: .spanish).string(format: .weekdayName, in: .spanish)

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
        XCTAssertEqual(Date.weekdayName(for: 1), "Sunday")
        XCTAssertEqual(Date.weekdayName(for: 2), "Monday")
        XCTAssertEqual(Date.weekdayName(for: 3), "Tuesday")
        XCTAssertEqual(Date.weekdayName(for: 4), "Wednesday")
        XCTAssertEqual(Date.weekdayName(for: 5), "Thursday")
        XCTAssertEqual(Date.weekdayName(for: 6), "Friday")
        XCTAssertEqual(Date.weekdayName(for: 7), "Saturday")

        XCTAssertEqual(Date.weekdayName(for: 1, in: .spanish), "domingo")
        XCTAssertEqual(Date.weekdayName(for: 2, in: .spanish), "lunes")
        XCTAssertEqual(Date.weekdayName(for: 3, in: .spanish), "martes")
        XCTAssertEqual(Date.weekdayName(for: 4, in: .spanish), "miércoles")
        XCTAssertEqual(Date.weekdayName(for: 5, in: .spanish), "jueves")
        XCTAssertEqual(Date.weekdayName(for: 6, in: .spanish), "viernes")
        XCTAssertEqual(Date.weekdayName(for: 7, in: .spanish), "sábado")
    }

    func testDateUnit() {
        let date = Date(year: 2020, month: 2, day: 1, hour: 3, minute: 41, second: 22)

        XCTAssertEqual(2020, date.component(.year))
        XCTAssertEqual(2, date.component(.month))
        XCTAssertEqual(1, date.component(.day))
        XCTAssertEqual(3, date.component(.hour))
        XCTAssertEqual(41, date.component(.minute))
        XCTAssertEqual(22, date.component(.second))

        // Test in different calendar.
        XCTAssertEqual(2020, date.component(.year, in: .usEastern))
        XCTAssertEqual(1, date.component(.month, in: .usEastern))
        XCTAssertEqual(31, date.component(.day, in: .usEastern))
        XCTAssertEqual(22, date.component(.hour, in: .usEastern))
        XCTAssertEqual(41, date.component(.minute, in: .usEastern))
        XCTAssertEqual(22, date.component(.second, in: .usEastern))
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

        let testMultipleCalendarDateLeft = Date(year: 2020, month: 4, day: 5, hour: 1, minute: 45, second: 33, calendar: .iso)
        let testMultipleCalendarDateRight = Date(year: 2020, month: 4, day: 4, hour: 21, minute: 45, second: 33, calendar: .usEastern)

        XCTAssert(testYearGranularityDateLeft.isSame(testYearGranularityDateRight, granularity: .year), "Year granularity failed")
        XCTAssert(testMonthGranularityDateLeft.isSame(testMonthGranularityDateRight, granularity: .month), "Month granularity failed")
        XCTAssert(testDayGranularityDateLeft.isSame(testDayGranularityDateRight, granularity: .day), "Day granularity failed")
        XCTAssert(testHourGranularityDateLeft.isSame(testHourGranularityDateRight, granularity: .hour), "Hour granularity failed")
        XCTAssert(testMinuteGranularityDateLeft.isSame(testMinuteGranularityDateRight, granularity: .minute), "Minute granularity failed")
        XCTAssert(testSecondsGranularityDateLeft.isSame(testSecondsGranularityDateRight, granularity: .second), "Seconds granularity failed")
        XCTAssert(testSecondsGranularityDateLeft.isSame(testSecondsGranularityDateRight, granularity: .nanosecond), "NanoSeconds granularity failed")
        XCTAssert(testMultipleCalendarDateLeft.isSame(testMultipleCalendarDateRight, granularity: .second), "Multi calendar test failed")
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

        let testMultipleCalendarDateLeft = Date(year: 2020, month: 4, day: 5, hour: 1, minute: 45, second: 33, calendar: .iso)
        let testMultipleCalendarDateRight = Date(year: 2020, month: 4, day: 4, hour: 21, minute: 46, second: 33, calendar: .usEastern)

        XCTAssert(testYearGranularityDateLeft.isBefore(testYearGranularityDateRight, granularity: .year), "Year granularity failed")
        XCTAssert(testMonthGranularityDateLeft.isBefore(testMonthGranularityDateRight, granularity: .month), "Month granularity failed")
        XCTAssert(testDayGranularityDateLeft.isBefore(testDayGranularityDateRight, granularity: .day), "Day granularity failed")
        XCTAssert(testHourGranularityDateLeft.isBefore(testHourGranularityDateRight, granularity: .hour), "Hour granularity failed")
        XCTAssert(testMinuteGranularityDateLeft.isBefore(testMinuteGranularityDateRight, granularity: .minute), "Minute granularity failed")
        XCTAssert(testSecondsGranularityDateLeft.isBefore(testSecondsGranularityDateRight, granularity: .second), "Seconds granularity failed")
        XCTAssert(testSecondsGranularityDateLeft.isBefore(testSecondsGranularityDateRight, granularity: .nanosecond), "NanoSeconds granularity failed")
        XCTAssert(testMultipleCalendarDateLeft.isBefore(testMultipleCalendarDateRight, granularity: .second), "Multi calendar test failed")
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

        let testMultipleCalendarDateLeft = Date(year: 2020, month: 4, day: 5, hour: 1, minute: 47, second: 33, calendar: .iso)
        let testMultipleCalendarDateRight = Date(year: 2020, month: 4, day: 4, hour: 21, minute: 46, second: 33, calendar: .usEastern)

        XCTAssert(testYearGranularityDateLeft.isAfter(testYearGranularityDateRight, granularity: .year), "Year granularity failed")
        XCTAssert(testMonthGranularityDateLeft.isAfter(testMonthGranularityDateRight, granularity: .month), "Month granularity failed")
        XCTAssert(testDayGranularityDateLeft.isAfter(testDayGranularityDateRight, granularity: .day), "Day granularity failed")
        XCTAssert(testHourGranularityDateLeft.isAfter(testHourGranularityDateRight, granularity: .hour), "Hour granularity failed")
        XCTAssert(testMinuteGranularityDateLeft.isAfter(testMinuteGranularityDateRight, granularity: .minute), "Minute granularity failed")
        XCTAssert(testSecondsGranularityDateLeft.isAfter(testSecondsGranularityDateRight, granularity: .second), "Seconds granularity failed")
        XCTAssert(testSecondsGranularityDateLeft.isAfter(testSecondsGranularityDateRight, granularity: .nanosecond), "NanoSeconds granularity failed")
        XCTAssert(testMultipleCalendarDateLeft.isAfter(testMultipleCalendarDateRight, granularity: .second), "Multi calendar test failed")
    }

    func testIsBetweenDate() {
        let testYearGranularityDateLeft = Date(year: 2019, month: 2, day: 1, hour: 3, minute: 41, second: 22)
        let testYearGranularityDateMid = Date(year: 2020, month: 4, day: 5, hour: 1, minute: 45, second: 33)
        let testYearGranularityDateRight = Date(year: 2021, month: 4, day: 5, hour: 1, minute: 45, second: 33)
        let testYearGranularityDateInterval = DateInterval(start: testYearGranularityDateLeft, end: testYearGranularityDateRight)

        let testMonthGranularityDateLeft = Date(year: 2020, month: 4, day: 1, hour: 3, minute: 41, second: 22)
        let testMonthGranularityDateMid = Date(year: 2020, month: 5, day: 5, hour: 1, minute: 45, second: 33)
        let testMonthGranularityDateRight = Date(year: 2020, month: 6, day: 5, hour: 1, minute: 45, second: 33)
        let testMonthGranularityDateInterval = DateInterval(start: testMonthGranularityDateLeft, end: testMonthGranularityDateRight)

        let testDayGranularityDateLeft = Date(year: 2020, month: 4, day: 5, hour: 3, minute: 41, second: 22)
        let testDayGranularityDateMid = Date(year: 2020, month: 4, day: 6, hour: 1, minute: 45, second: 33)
        let testDayGranularityDateRight = Date(year: 2020, month: 4, day: 7, hour: 1, minute: 45, second: 33)
        let testDayGranularityDateInterval = DateInterval(start: testDayGranularityDateLeft, end: testDayGranularityDateRight)

        let testHourGranularityDateLeft = Date(year: 2020, month: 4, day: 5, hour: 1, minute: 41, second: 22)
        let testHourGranularityDateMid = Date(year: 2020, month: 4, day: 5, hour: 2, minute: 45, second: 33)
        let testHourGranularityDateRight = Date(year: 2020, month: 4, day: 5, hour: 3, minute: 45, second: 33)
        let testHourGranularityDateInterval = DateInterval(start: testHourGranularityDateLeft, end: testHourGranularityDateRight)

        let testMinuteGranularityDateLeft = Date(year: 2020, month: 4, day: 5, hour: 1, minute: 45, second: 22)
        let testMinuteGranularityDateMid = Date(year: 2020, month: 4, day: 5, hour: 1, minute: 55, second: 33)
        let testMinuteGranularityDateRight = Date(year: 2020, month: 4, day: 5, hour: 1, minute: 59, second: 33)
        let testMinuteGranularityDateInterval = DateInterval(start: testMinuteGranularityDateLeft, end: testMinuteGranularityDateRight)

        let testSecondsGranularityDateLeft = Date(year: 2020, month: 4, day: 5, hour: 1, minute: 45, second: 33)
        let testSecondsGranularityDateMid = Date(year: 2020, month: 4, day: 5, hour: 1, minute: 45, second: 44)
        let testSecondsGranularityDateRight = Date(year: 2020, month: 4, day: 5, hour: 1, minute: 45, second: 55)
        let testSecondsGranularityDateInterval = DateInterval(start: testSecondsGranularityDateLeft, end: testSecondsGranularityDateRight)

        let testMultipleCalendarDateLeft = Date(year: 2020, month: 4, day: 4, hour: 21, minute: 30, second: 33, calendar: .usEastern)
        let testMultipleCalendarDateMid = Date(year: 2020, month: 4, day: 5, hour: 4, minute: 36, second: 33, calendar: .turkey)
        let testMultipleCalendarDateRight = Date(year: 2020, month: 4, day: 5, hour: 1, minute: 47, second: 33, calendar: .iso)
        let testMultipleCalendarDateInterval = DateInterval(start: testMultipleCalendarDateLeft, end: testMultipleCalendarDateRight)

        XCTAssert(testYearGranularityDateMid.isBetween(testYearGranularityDateInterval, granularity: .year), "Year granularity failed")
        XCTAssert(testMonthGranularityDateMid.isBetween(testMonthGranularityDateInterval, granularity: .month), "Month granularity failed")
        XCTAssert(testDayGranularityDateMid.isBetween(testDayGranularityDateInterval, granularity: .day), "Day granularity failed")
        XCTAssert(testHourGranularityDateMid.isBetween(testHourGranularityDateInterval, granularity: .hour), "Hour granularity failed")
        XCTAssert(testMinuteGranularityDateMid.isBetween(testMinuteGranularityDateInterval, granularity: .minute), "Minute granularity failed")
        XCTAssert(testSecondsGranularityDateMid.isBetween(testSecondsGranularityDateInterval, granularity: .second), "Seconds granularity failed")
        XCTAssert(testSecondsGranularityDateMid.isBetween(testSecondsGranularityDateInterval, granularity: .nanosecond), "NanoSeconds granularity failed")
        XCTAssert(testMultipleCalendarDateMid.isBetween(testMultipleCalendarDateInterval, granularity: .second), "Multi calendar test failed")
    }

    func testNumberOf() {
        let date = Date(year: 2019, month: 3, day: 4, hour: 2, minute: 22, second: 44)
        let anotherDate = Date(year: 2020, month: 4, day: 5, hour: 1, minute: 45, second: 55)
        XCTAssertEqual(1, date.numberOf(.year, to: anotherDate))
        XCTAssertEqual(13, date.numberOf(.month, to: anotherDate))
        XCTAssertEqual(56, date.numberOf(.weekOfYear, to: anotherDate))
        XCTAssertEqual(397, date.numberOf(.day, to: anotherDate))
        XCTAssertEqual(9551, date.numberOf(.hour, to: anotherDate))
        XCTAssertEqual(573_083, date.numberOf(.minute, to: anotherDate))
        XCTAssertEqual(34_384_991, date.numberOf(.second, to: anotherDate))
    }

    func testTimeZone() {
        XCTAssertEqual(Date.timeZoneOffset(calendar: .usEastern), -4)
        XCTAssertEqual(Date.timeZoneOffset(calendar: .iso), 0)
        XCTAssertEqual(Date.timeZoneOffset(calendar: .turkey), 3)
    }

    func testTotalDayInMonth() {
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

        XCTAssertEqual(jan.monthDays, 31)
        XCTAssertEqual(leapYearFeb.monthDays, 29)
        XCTAssertEqual(nonLeapYearFeb.monthDays, 28)
        XCTAssertEqual(mar.monthDays, 31)
        XCTAssertEqual(apr.monthDays, 30)
        XCTAssertEqual(may.monthDays, 31)
        XCTAssertEqual(jun.monthDays, 30)
        XCTAssertEqual(jul.monthDays, 31)
        XCTAssertEqual(aug.monthDays, 31)
        XCTAssertEqual(sep.monthDays, 30)
        XCTAssertEqual(oct.monthDays, 31)
        XCTAssertEqual(nov.monthDays, 30)
        XCTAssertEqual(dec.monthDays, 31)
    }

    func testAdjustmentWithDateComponents() {
        let dateToAdjust = Date(year: 2020, month: 3, day: 1, hour: 3, minute: 41, second: 22)
        var dateComponents = DateComponents()
        dateComponents.year = 1
        dateComponents.month = -2
        dateComponents.day = 3

        let expectedResult = Date(year: 2021, month: 1, day: 4, hour: 3, minute: 41, second: 22)
        XCTAssertEqual(expectedResult, dateToAdjust.adjusting(dateComponents))
    }

    func testComparisonOperatorDay() {
        let today = Date()
        XCTAssertTrue(today.is(.today))
        XCTAssertFalse(today.is(.tomorrow))
        XCTAssertFalse(today.is(.yesterday))

        let tomorrow = Date().adjusting(.day, by: 1)
        XCTAssertFalse(tomorrow.is(.today))
        XCTAssertTrue(tomorrow.is(.tomorrow))
        XCTAssertFalse(tomorrow.is(.yesterday))

        let yesterday = Date().adjusting(.day, by: -1)
        XCTAssertFalse(yesterday.is(.today))
        XCTAssertFalse(yesterday.is(.tomorrow))
        XCTAssertTrue(yesterday.is(.yesterday))

        let date = Date(year: 3020, month: 2, day: 1, hour: 3, minute: 41, second: 22)
        XCTAssertFalse(date.is(.yesterday))
        XCTAssertFalse(date.is(.today))
        XCTAssertFalse(date.is(.tomorrow))
    }

    func testComparisonOperatorNext() {
        let now = Date()
        let previousDate = Date(year: 3020, month: 2, day: 1, hour: 3, minute: 41, second: 22)

        let futureDate_Day = now.adjusting(.day, by: 10)
        let nextDate_Day = now.adjusting(.day, by: 1)
        let nextDate_Weekday = now.adjusting(.weekday, by: 1)
        let nextDate_Month = now.adjusting(.month, by: 1)
        let nextDate_Year = now.adjusting(.year, by: 1)

        XCTAssertFalse(previousDate.is(.next(.day)))
        XCTAssertFalse(previousDate.is(.next(.weekday)))
        XCTAssertFalse(previousDate.is(.next(.month)))
        XCTAssertFalse(previousDate.is(.next(.year)))

        XCTAssertFalse(futureDate_Day.is(.tomorrow), "Expected \(futureDate_Day.component(.day)) to not be tomorrow.")
        XCTAssertTrue(nextDate_Day.is(.tomorrow), "Expected \(nextDate_Day.component(.day)) to be tomorrow.")
        XCTAssertTrue(nextDate_Day.is(.next(.day)), "Expected \(nextDate_Day.component(.day)) to be next day after \(now.component(.day)).")
        XCTAssertTrue(nextDate_Weekday.is(.next(.weekday)), "Expected \(nextDate_Weekday.component(.weekday)) to be next weekday after \(now.component(.weekday)).")
        XCTAssertTrue(nextDate_Month.is(.next(.month)), "Expected \(nextDate_Month.component(.month)) to be next month after \(now.component(.month)).")
        XCTAssertTrue(nextDate_Year.is(.next(.year)), "Expected \(nextDate_Year.component(.year)) to be next year after \(now.component(.year)).")
    }

    func testComparisonOperatorPrevious() {
        let now = Date()
        let nextDate = Date(year: 3020, month: 2, day: 1, hour: 3, minute: 41, second: 22)

        let pastDate_Day = now.adjusting(.day, by: -10)
        let previousDate_Day = now.adjusting(.day, by: -1)
        let previousDate_Weekday = now.adjusting(.weekday, by: -1)
        let previousDate_Month = now.adjusting(.month, by: -1)
        let previousDate_Year = now.adjusting(.year, by: -1)

        XCTAssertFalse(nextDate.is(.previous(.day)))
        XCTAssertFalse(nextDate.is(.previous(.weekday)))
        XCTAssertFalse(nextDate.is(.previous(.month)))
        XCTAssertFalse(nextDate.is(.previous(.year)))

        XCTAssertFalse(pastDate_Day.is(.yesterday), "Expected \(pastDate_Day.component(.day)) to not be yesterday.")
        XCTAssertTrue(previousDate_Day.is(.yesterday), "Expected \(previousDate_Day.component(.day)) to be yesterday.")
        XCTAssertTrue(previousDate_Day.is(.previous(.day)), "Expected \(previousDate_Day.component(.day)) to be a day before \(now.component(.day)).")
        XCTAssertTrue(previousDate_Weekday.is(.previous(.weekday)), "Expected \(previousDate_Weekday.component(.weekday)) to be a weekday \(now.component(.weekday)).")
        XCTAssertTrue(previousDate_Month.is(.previous(.month)), "Expected \(previousDate_Month.component(.month)) to be a month before \(now.component(.month)).")
        XCTAssertTrue(previousDate_Year.is(.previous(.year)), "Expected \(previousDate_Year.component(.year)) to be a year before \(now.component(.year)).")
    }

    func testComparisonOperatorPast() {
        let now = Date()
        let nextDate = Date(year: 3020, month: 2, day: 1, hour: 3, minute: 41, second: 22)
        let previousDate = Date(year: 1020, month: 2, day: 1, hour: 3, minute: 41, second: 22)

        let pastDate_Day = now.adjusting(.day, by: -10)
        let pastDate_Weekday = now.adjusting(.weekday, by: -10)
        let pastDate_Month = now.adjusting(.month, by: -10)
        let pastDate_Year = now.adjusting(.year, by: -10)

        XCTAssertFalse(nextDate.is(.past(.day)))
        XCTAssertFalse(nextDate.is(.past(.weekday)))
        XCTAssertFalse(nextDate.is(.past(.month)))
        XCTAssertFalse(nextDate.is(.past(.year)))

        XCTAssertTrue(previousDate.is(.past(.day)))
        XCTAssertTrue(previousDate.is(.past(.weekday)))
        XCTAssertTrue(previousDate.is(.past(.month)))
        XCTAssertTrue(previousDate.is(.past(.year)))

        XCTAssertTrue(pastDate_Day.is(.past(.day)), "Expected \(pastDate_Day.component(.day)) to be day past \(now.component(.day)).")
        XCTAssertTrue(pastDate_Weekday.is(.past(.weekday)), "Expected \(pastDate_Weekday.component(.weekday)) to be weekday past \(now.component(.weekday)).")
        XCTAssertTrue(pastDate_Month.is(.past(.month)), "Expected \(pastDate_Month.component(.month)) to be month past \(now.component(.month)).")
        XCTAssertTrue(pastDate_Year.is(.past(.year)), "Expected \(pastDate_Year.component(.year)) to be year past \(now.component(.year)).")
    }

    func testComparisonOperatorFuture() {
        let now = Date()
        let nextDate = Date(year: 3020, month: 2, day: 1, hour: 3, minute: 41, second: 22)
        let previousDate = Date(year: 1020, month: 2, day: 1, hour: 3, minute: 41, second: 22)

        let futureDate_Day = now.adjusting(.day, by: 10)
        let futureDate_Weekday = now.adjusting(.weekday, by: 10)
        let futureDate_Month = now.adjusting(.month, by: 10)
        let futureDate_Year = now.adjusting(.year, by: 10)

        XCTAssertTrue(nextDate.is(.future(.day)))
        XCTAssertTrue(nextDate.is(.future(.weekday)))
        XCTAssertTrue(nextDate.is(.future(.month)))
        XCTAssertTrue(nextDate.is(.future(.year)))

        XCTAssertFalse(previousDate.is(.future(.day)))
        XCTAssertFalse(previousDate.is(.future(.weekday)))
        XCTAssertFalse(previousDate.is(.future(.month)))
        XCTAssertFalse(previousDate.is(.future(.year)))

        XCTAssertTrue(futureDate_Day.is(.future(.day)), "Expected \(futureDate_Day.component(.day)) to be day future \(now.component(.day)).")
        XCTAssertTrue(futureDate_Weekday.is(.future(.weekday)), "Expected \(futureDate_Weekday.component(.weekday)) to be weekday future \(now.component(.weekday)).")
        XCTAssertTrue(futureDate_Month.is(.future(.month)), "Expected \(futureDate_Month.component(.month)) to be month future \(now.component(.month)).")
        XCTAssertTrue(futureDate_Year.is(.future(.year)), "Expected \(futureDate_Year.component(.year)) to be year future \(now.component(.year)).")
    }

    func testComparisonOperatorCurrent() {
        let now = Date()
        let nextDate = Date(year: 3020, month: 2, day: 1, hour: 3, minute: 41, second: 22)
        let previousDate = Date(year: 1020, month: 2, day: 1, hour: 3, minute: 41, second: 22)

        let currentDate_Day = now
        let currentDate_Weekday = now
        let currentDate_Month = now
        let currentDate_Year = now

        XCTAssertFalse(nextDate.is(.current(.day)))
        XCTAssertFalse(nextDate.is(.current(.weekday)))
        XCTAssertFalse(nextDate.is(.current(.month)))
        XCTAssertFalse(nextDate.is(.current(.year)))

        XCTAssertFalse(previousDate.is(.current(.day)))
        XCTAssertFalse(previousDate.is(.current(.weekday)))
        XCTAssertFalse(previousDate.is(.current(.month)))
        XCTAssertFalse(previousDate.is(.current(.year)))

        XCTAssertTrue(currentDate_Day.is(.current(.day)), "Expected \(currentDate_Day.component(.day)) to be day current \(now.component(.day)).")
        XCTAssertTrue(currentDate_Weekday.is(.current(.weekday)), "Expected \(currentDate_Weekday.component(.weekday)) to be weekday current \(now.component(.weekday)).")
        XCTAssertTrue(currentDate_Month.is(.current(.month)), "Expected \(currentDate_Month.component(.month)) to be month current \(now.component(.month)).")
        XCTAssertTrue(currentDate_Year.is(.current(.year)), "Expected \(currentDate_Year.component(.year)) to be year current \(now.component(.year)).")
    }

    func testDateIntervalsStaticDates() {
        // Week
        let thisWeekStartDate = Date(year: 2020, month: 1, day: 5, hour: 0, minute: 0, second: 0)
        let thisWeekEndDate = Date(year: 2020, month: 1, day: 11, hour: 23, minute: 59, second: 59)
        let thisWeek = thisWeekStartDate.interval(for: .weekOfYear)
        XCTAssert(thisWeek.start == thisWeekStartDate, "Expected \(thisWeek.start) to equal \(thisWeekStartDate)")
        XCTAssert(thisWeek.end.stripMillisecond() == thisWeekEndDate, "Expected \(thisWeek.end) to equal \(thisWeekEndDate)")

        let lastWeekStartDate = Date(year: 2019, month: 12, day: 29, hour: 0, minute: 0, second: 0)
        let lastWeekEndDate = Date(year: 2020, month: 1, day: 4, hour: 23, minute: 59, second: 59)
        let lastWeek = thisWeekStartDate.interval(for: .weekOfYear, adjustedBy: -1)
        XCTAssertTrue(lastWeek.start == lastWeekStartDate, "Expected \(lastWeek.start) to equal \(lastWeekStartDate)")
        XCTAssert(lastWeek.end.stripMillisecond() == lastWeekEndDate, "Expected \(lastWeek.end) to equal \(lastWeekEndDate)")

        // Month
        let thisMonthStartDate = Date(year: 2020, month: 2, day: 1, hour: 0, minute: 0, second: 0)
        let thisMonthEndDate = Date(year: 2020, month: 2, day: 29, hour: 23, minute: 59, second: 59)
        let thisMonth = thisMonthStartDate.interval(for: .month)
        XCTAssert(thisMonth.start == thisMonthStartDate, "Expected \(thisMonth.start) to equal \(thisMonthStartDate)")
        XCTAssert(thisMonth.end.stripMillisecond() == thisMonthEndDate, "Expected \(thisMonth.end) to equal \(thisMonthEndDate)")

        let lastMonthStartDate = Date(year: 2020, month: 1, day: 1, hour: 0, minute: 0, second: 0)
        let lastMonthEndDate = Date(year: 2020, month: 1, day: 31, hour: 23, minute: 59, second: 59)
        let lastMonth = thisMonthStartDate.interval(for: .month, adjustedBy: -1)
        XCTAssertTrue(lastMonth.start == lastMonthStartDate, "Expected \(lastMonth.start) to equal \(lastMonthStartDate)")
        XCTAssert(lastMonth.end.stripMillisecond() == lastMonthEndDate, "Expected \(lastMonth.end) to equal \(lastMonthEndDate)")

        // Year
        let thisYearStartDate = Date(year: 2020, month: 1, day: 1, hour: 0, minute: 0, second: 0)
        let thisYearEndDate = Date(year: 2020, month: 12, day: 31, hour: 23, minute: 59, second: 59)
        let thisYear = thisYearStartDate.interval(for: .year)
        XCTAssert(thisYear.start == thisYearStartDate, "Expected \(thisYear.start) to equal \(thisYearStartDate)")
        XCTAssert(thisYear.end.stripMillisecond() == thisYearEndDate, "Expected \(thisYear.end) to equal \(thisYearEndDate)")

        let lastYearStartDate = Date(year: 2019, month: 1, day: 1, hour: 0, minute: 0, second: 0)
        let lastYearEndDate = Date(year: 2019, month: 12, day: 31, hour: 23, minute: 59, second: 59)
        let lastYear = thisYearStartDate.interval(for: .year, adjustedBy: -1)
        XCTAssertTrue(lastYear.start == lastYearStartDate, "Expected \(lastYear.start) to equal \(lastYearStartDate)")
        XCTAssert(lastYear.end.stripMillisecond() == lastYearEndDate, "Expected \(lastYear.end) to equal \(lastYearEndDate)")
    }

    func testDateIntervalBulk() {
        let components: [Calendar.Component] = [
            .weekOfYear,
            .month,
            .year
        ]

        // Current
        for component in components {
            let interval = Date().interval(for: component)
            let date = Date().startOf(component)
            XCTAssert(interval.start == date)
            XCTAssert(interval.end == date.endOf(component))
        }

        // Previous
        for component in components {
            let interval = Date().interval(for: component, adjustedBy: -1)
            let date = Date().startOf(component).adjusting(component, by: -1)
            XCTAssert(interval.start == date)
            XCTAssert(interval.end == date.endOf(component))
        }
    }

    func testDateIntervalLiveDates() {
        // Week
        let lastWeek = DateInterval.lastWeek
        XCTAssert(lastWeek.start == Date().startOf(.weekOfYear).adjusting(.weekOfYear, by: -1))
        XCTAssert(lastWeek.end == Date().startOf(.weekOfYear).adjusting(.weekOfYear, by: -1).endOf(.weekOfYear))

        let thisWeek = DateInterval.thisWeek
        XCTAssert(thisWeek.start == Date().startOf(.weekOfYear))
        XCTAssert(thisWeek.end == Date().endOf(.weekOfYear))

        // Month
        let lastMonth = DateInterval.lastMonth
        XCTAssert(lastMonth.start == Date().startOf(.month).adjusting(.month, by: -1))
        XCTAssert(lastMonth.end == Date().startOf(.month).adjusting(.month, by: -1).endOf(.month))

        let thisMonth = DateInterval.thisMonth
        XCTAssert(thisMonth.start == Date().startOf(.month))
        XCTAssert(thisMonth.end == Date().endOf(.month))

        // Year
        let lastYear = DateInterval.lastYear
        XCTAssert(lastYear.start == Date().startOf(.year).adjusting(.year, by: -1))
        XCTAssert(lastYear.end == Date().startOf(.year).adjusting(.year, by: -1).endOf(.year))

        let thisYear = DateInterval.thisYear
        XCTAssert(thisYear.start == Date().startOf(.year))
        XCTAssert(thisYear.end == Date().endOf(.year))
    }
}

extension Calendar {
    fileprivate static let spanish = Self(
        identifier: .gregorian
    ).applying {
        $0.timeZone = .gmt
        $0.locale = .es
    }

    fileprivate static let turkey = Self(
        identifier: .gregorian
    ).applying {
        $0.timeZone = .istanbul
        $0.locale = .tr
    }

    fileprivate static let usEastern = Self(
        identifier: .gregorian
    ).applying {
        $0.timeZone = .eastern
        $0.locale = .current
    }
}

// MARK: - DateInterval

extension DateInterval {
    fileprivate static var thisWeek: Self {
        Date().interval(for: .weekOfYear)
    }

    fileprivate static var lastWeek: Self {
        Date().interval(for: .weekOfYear, adjustedBy: -1)
    }

    fileprivate static var thisMonth: Self {
        Date().interval(for: .month)
    }

    fileprivate static var lastMonth: Self {
        Date().interval(for: .month, adjustedBy: -1)
    }

    fileprivate static var thisYear: Self {
        Date().interval(for: .year)
    }

    fileprivate static var lastYear: Self {
        Date().interval(for: .year, adjustedBy: -1)
    }
}

extension Date {
    fileprivate func stripMillisecond(calendar: Calendar = .default) -> Date {
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
        return calendar.date(from: components) ?? self
    }
}
