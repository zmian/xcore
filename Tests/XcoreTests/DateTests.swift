//
// Xcore
// Copyright © 2018 Xcore
// MIT license, see LICENSE file for details
//
// swiftlint:disable empty_string

import Testing
import Foundation
@testable import Xcore

@Suite(.serialized)
struct DateTest {
    init() {
        Calendar.default = .iso
    }

    @Test
    func basics_year() {
        let string = "2022"
        let date = Date(year: 2022, month: 1, day: 1)
        let format = Date.FormatStyle
            .dateTime
            .year()
            .calendarTimeZoneLocale(.default)

        let formattedDate = date.formatted(format)
        #expect(formattedDate == string)

        let parsedDate = try? Date(string, strategy: format)
        #expect(parsedDate == date)
    }

    @Test
    func iso8601_ymd() {
        let string = "2000-01-01"
        let date = Date(year: 2000, month: 1, day: 1)
        let format = Date.ISO8601FormatStyle
            .iso8601
            .date()
            .timeZone(Calendar.default.timeZone)

        let formattedDate = date.formatted(format)
        #expect(formattedDate == string)

        let parsedDate = try? Date(string, strategy: format)
        #expect(parsedDate == date)
    }

    @Test
    func iso8601_ymd_hms() {
        let string = "2000-01-01T09:41:00"
        let date = Date(year: 2000, month: 1, day: 1, hour: 9, minute: 41)
        let format = Date.ISO8601FormatStyle
            .iso8601
            .date()
            .time(includingFractionalSeconds: false)
            .timeZone(Calendar.default.timeZone)

        let formattedDate = date.formatted(format)
        #expect(formattedDate == string)

        let parsedDate = try? Date(string, strategy: format)
        #expect(parsedDate == date)
    }

    @Test
    func iso8601_ymd_hms_sssz() {
        let string = "2000-01-01T09:41:10.000+0000"
        let date = Date(year: 2000, month: 1, day: 1, hour: 9, minute: 41, second: 10)
        let format = Date.ISO8601FormatStyle
            .iso8601
            .date()
            .time(includingFractionalSeconds: true)
            .timeZone(Calendar.default.timeZone)

        let formattedDate = date.formatted(format)
        #expect(formattedDate == "2000-01-01T09:41:10.000")

        let parsedDate = try? Date(string, strategy: format)
        #expect(parsedDate == date)
    }

    @Test
    func formatted_style_dateTime_part_1() {
        let date = Date(year: 2000, month: 1, day: 1, hour: 9, minute: 41)

        // .date(.full)
        #expect(date.formatted(style: .date(.complete)) == "Saturday, January 1, 2000")
        #expect(date.formatted(style: .dateTime(.complete, time: .complete)) == "Saturday, January 1, 2000 at 9:41:00 AM GMT")

        // .date(.long)
        #expect(date.formatted(style: .date(.long)) == "January 1, 2000")
        #expect(date.formatted(style: .dateTime(.long, time: .standard)) == "January 1, 2000 at 9:41:00 AM")

        // .date(.medium)
        #expect(date.formatted(style: .date(.abbreviated)) == "Jan 1, 2000")
        #expect(date.formatted(style: .dateTime(.abbreviated, time: .shortened)) == "Jan 1, 2000 at 9:41 AM")

        // .date(.short)
        #expect(date.formatted(style: .date(.numeric)) == "1/1/2000")
        #expect(date.formatted(style: .dateTime(.numeric, time: .shortened)) == "1/1/2000, 9:41 AM")

        #expect(date.formatted(style: .dateTime(.omitted, time: .omitted)) == "")
        #expect(date.formatted(style: .dateTime(.numeric, time: .shortened)) == "1/1/2000, 9:41 AM")
        #expect(date.formatted(style: .dateTime(.abbreviated, time: .standard)) == "Jan 1, 2000 at 9:41:00 AM")
        #expect(date.formatted(style: .dateTime(.abbreviated, time: .shortened)) == "Jan 1, 2000 at 9:41 AM")
        #expect(date.formatted(style: .dateTime(.long, time: .shortened)) == "January 1, 2000 at 9:41 AM")
        #expect(date.formatted(style: .dateTime(.complete, time: .shortened)) == "Saturday, January 1, 2000 at 9:41 AM")
    }

    @Test
    func formatted_style_dateTime_part_2() {
        let date = Date(year: 2022, month: 6, day: 4, hour: 11, minute: 11, second: 22)

        // .long
        #expect(date.formatted(Date.FormatStyle(date: .long).calendarTimeZoneLocale(.default)) == "June 4, 2022")
        #expect(date.formatted(Date.FormatStyle(date: .long, time: .shortened).calendarTimeZoneLocale(.default)) == "June 4, 2022 at 11:11 AM")

        #expect(date.formatted(style: .date(.long)) == "June 4, 2022")
        #expect(date.formatted(style: .dateTime(.long, time: .shortened)) == "June 4, 2022 at 11:11 AM")

        // .abbreviated
        #expect(date.formatted(Date.FormatStyle(date: .abbreviated).calendarTimeZoneLocale(.default)) == "Jun 4, 2022")
        #expect(date.formatted(Date.FormatStyle(date: .abbreviated, time: .shortened).calendarTimeZoneLocale(.default)) == "Jun 4, 2022 at 11:11 AM")

        #expect(date.formatted(style: .date(.abbreviated)) == "Jun 4, 2022")
        #expect(date.formatted(style: .dateTime(.abbreviated, time: .shortened)) == "Jun 4, 2022 at 11:11 AM")

        // .numeric
        #expect(date.formatted(Date.FormatStyle(date: .numeric).calendarTimeZoneLocale(.default)) == "6/4/2022")
        #expect(date.formatted(Date.FormatStyle(date: .numeric, time: .shortened).calendarTimeZoneLocale(.default)) == "6/4/2022, 11:11 AM")

        #expect(date.formatted(style: .date(.numeric)) == "6/4/2022")
        #expect(date.formatted(style: .dateTime(.numeric, time: .shortened)) == "6/4/2022, 11:11 AM")

        // .complete
        #expect(date.formatted(Date.FormatStyle(date: .complete).calendarTimeZoneLocale(.default)) == "Saturday, June 4, 2022")
        #expect(date.formatted(Date.FormatStyle(date: .complete, time: .shortened).calendarTimeZoneLocale(.default)) == "Saturday, June 4, 2022 at 11:11 AM")

        #expect(date.formatted(style: .date(.complete)) == "Saturday, June 4, 2022")
        #expect(date.formatted(style: .dateTime(.complete, time: .shortened)) == "Saturday, June 4, 2022 at 11:11 AM")
    }

    @Test
    func formatted_style_dateTime_month_day() {
        let date = Date(year: 2022, month: 6, day: 4, hour: 11, minute: 11, second: 22)

        // .long
        #expect(date.formatted(.dateTime.month(.wide).day().calendarTimeZoneLocale(.default)) == "June 4")
        #expect(date.formatted(Date.FormatStyle(time: .shortened).month(.wide).day().calendarTimeZoneLocale(.default)) == "June 4 at 11:11 AM")

        // .abbreviated
        #expect(date.formatted(.dateTime.month().day().calendarTimeZoneLocale(.default)) == "Jun 4")
        #expect(date.formatted(Date.FormatStyle(time: .shortened).month().day().calendarTimeZoneLocale(.default)) == "Jun 4 at 11:11 AM")

        // .numeric
        #expect(date.formatted(.dateTime.month(.defaultDigits).day().calendarTimeZoneLocale(.default)) == "6/4")
        #expect(date.formatted(Date.FormatStyle(time: .shortened).month(.defaultDigits).day().calendarTimeZoneLocale(.default)) == "6/4, 11:11 AM")
    }

    @Test
    func formatted_style_dateTime_month_year() {
        let date = Date(year: 2022, month: 6, day: 4, hour: 11, minute: 11, second: 22)

        // .long
        #expect(date.formatted(.dateTime.month(.wide).year().calendarTimeZoneLocale(.default)) == "June 2022")
        #expect(date.formatted(Date.FormatStyle(time: .shortened).month(.wide).year().calendarTimeZoneLocale(.default)) == "June 2022 at 11:11 AM")

        // .abbreviated
        #expect(date.formatted(.dateTime.month().year().calendarTimeZoneLocale(.default)) == "Jun 2022")
        #expect(date.formatted(Date.FormatStyle(time: .shortened).month().year().calendarTimeZoneLocale(.default)) == "Jun 2022 at 11:11 AM")

        // .numeric
        #expect(date.formatted(.dateTime.month(.defaultDigits).year().calendarTimeZoneLocale(.default)) == "6/2022")
        #expect(date.formatted(Date.FormatStyle(time: .shortened).month(.defaultDigits).year().calendarTimeZoneLocale(.default)) == "6/2022, 11:11 AM")
    }

    @Test
    func formatted_style_monthDayOrdinal() {
        // Test that May abbreviation should not contain period (e.g., May 3rd).
        let mayDate = Date(year: 2022, month: 5, day: 3, hour: 11, minute: 11, second: 22)
        let mayExpectedResult = "May 3rd"
        let mayResult = mayDate.formatted(style: .monthDayOrdinal(.abbreviated))
        #expect(mayExpectedResult == mayResult)

        // Test that June abbreviation should not contain period (e.g., Jun 4th).
        let juneDate = Date(year: 2022, month: 6, day: 4, hour: 11, minute: 11, second: 22)
        let juneExpectedResult = "Jun 4th"
        let juneResult = juneDate.formatted(style: .monthDayOrdinal(.abbreviated))
        #expect(juneExpectedResult == juneResult)

        #expect(juneDate.formatted(style: .monthDayOrdinal) == "June 4th")
        #expect(juneDate.formatted(style: .monthDayOrdinal(.wide)) == "June 4th")
        #expect(juneDate.formatted(style: .monthDayOrdinal(.abbreviated)) == "Jun 4th")
        #expect(juneDate.formatted(style: .monthDayOrdinal(.narrow)) == "J 4th")
    }

    @Test
    func formatted_relative_calculation() {
        let date = Date()
        #expect("Today" == date.formatted(style: .date(.long), doesRelativeDateFormatting: true))
        #expect("hoy" == date.formatted(style: .date(.long), doesRelativeDateFormatting: true, in: .spanish))
    }

    @Test
    func formatted_relative_until_era() {
        let relative = Date.Style.relative(until: .era)

        let yesterday = Date().adjusting(.day, by: -1)
        let now = Date()
        let hourAgo = Date().adjusting(.hour, by: 1)
        let twoAgo = Date().adjusting(.hour, by: 2)
        let tomorrow = Date().adjusting(.day, by: 1)
        let twoMonthFromNow = Date().adjusting(.month, by: 2)
        let twoMonthAgo = Date().adjusting(.month, by: -2)
        let year2000 = Date(year: 2000, month: 1, day: 1, hour: 9, minute: 41)

        #expect(yesterday.formatted(style: relative) == "Yesterday")
        #expect(now.formatted(style: relative) == "Today")
        #expect(hourAgo.formatted(style: relative) == "In 1 hour")
        #expect(twoAgo.formatted(style: relative) == "In 2 hours")
        #expect(tomorrow.formatted(style: relative) == "Tomorrow")
        #expect(twoMonthFromNow.formatted(style: relative) == "In 2 months")
        #expect(twoMonthAgo.formatted(style: relative) == "2 months ago")
        #expect(year2000.formatted(style: relative) == "25 years ago")
    }

    @Test
    func formatted_relative_until_month() {
        let relative = Date.Style.relative(until: .month)

        let yesterday = Date().adjusting(.day, by: -1)
        let now = Date()
        let hourAgo = Date().adjusting(.hour, by: 1)
        let twoAgo = Date().adjusting(.hour, by: 2)
        let tomorrow = Date().adjusting(.day, by: 1)

        let twoMonthFromNow = Date().adjusting(.month, by: 2)
        let twoMonthAgo = Date().adjusting(.month, by: -2)
        let year2000 = Date(year: 2000, month: 1, day: 1, hour: 9, minute: 41)

        #expect(yesterday.formatted(style: relative) == "Yesterday")
        #expect(now.formatted(style: relative) == "Today")
        #expect(hourAgo.formatted(style: relative) == "In 1 hour")
        #expect(twoAgo.formatted(style: relative) == "In 2 hours")
        #expect(tomorrow.formatted(style: relative) == "Tomorrow")

        #expect(twoMonthFromNow.formatted(style: relative) == twoMonthFromNow.formatted(style: .date(.abbreviated)))
        #expect(twoMonthAgo.formatted(style: relative) == twoMonthAgo.formatted(style: .date(.abbreviated)))
        #expect(year2000.formatted(style: relative) == "Jan 1, 2000")
    }

    @Test
    func formatted_convenience_style() {
        let now = Date()
        #expect(now.formatted(style: .relative) == "Today")

        let year2000 = Date(year: 2000, month: 1, day: 1, hour: 9, minute: 41)

        // Current
        #expect(year2000.formatted(style: .wide) == "January 1, 2000")
        #expect(year2000.formatted(style: .medium) == "Jan 1, 2000")
        #expect(year2000.formatted(style: .mediumWithTime) == "Jan 1, 2000 at 9:41 AM")
        #expect(year2000.formatted(style: .narrow) == "1/1/2000")
        #expect(year2000.formatted(style: .narrowWithTime) == "1/1/2000, 9:41 AM")
        #expect(year2000.formatted(style: .time) == "9:41 AM")

        // London
        #expect(year2000.formatted(style: .wide, in: .london) == "1 January 2000")
        #expect(year2000.formatted(style: .medium, in: .london) == "1 Jan 2000")
        #expect(year2000.formatted(style: .mediumWithTime, in: .london) == "1 Jan 2000 at 9:41")
        #expect(year2000.formatted(style: .narrow, in: .london) == "01/01/2000")
        #expect(year2000.formatted(style: .narrowWithTime, in: .london) == "01/01/2000, 9:41")
        #expect(year2000.formatted(style: .time, in: .london) == "9:41")

        // Spanish
        #expect(year2000.formatted(style: .wide, in: .spanish) == "1 de enero de 2000")
        #expect(year2000.formatted(style: .medium, in: .spanish) == "1 ene 2000")
        #expect(year2000.formatted(style: .mediumWithTime, in: .spanish) == "1 ene 2000, 9:41")
        #expect(year2000.formatted(style: .narrow, in: .spanish) == "1/1/2000")
        #expect(year2000.formatted(style: .narrowWithTime, in: .spanish) == "1/1/2000, 9:41")
        #expect(year2000.formatted(style: .time, in: .spanish) == "9:41")

        // Turkey
        #expect(year2000.formatted(style: .wide, in: .turkey) == "1 Ocak 2000")
        #expect(year2000.formatted(style: .medium, in: .turkey) == "1 Oca 2000")
        #expect(year2000.formatted(style: .mediumWithTime, in: .turkey) == "1 Oca 2000 11:41")
        #expect(year2000.formatted(style: .narrow, in: .turkey) == "1.01.2000")
        #expect(year2000.formatted(style: .narrowWithTime, in: .turkey) == "1.01.2000 11:41")
        #expect(year2000.formatted(style: .time, in: .turkey) == "11:41")
    }

    @Test
    func formatted_monthName() {
        let jan = Date(year: 2022, month: 1, day: 31, hour: 23, minute: 59, second: 59).formatted(style: .monthName)
        let feb = Date(year: 2022, month: 2, day: 4, hour: 21, minute: 11, second: 22).formatted(style: .monthName)
        let mar = Date(year: 2022, month: 3, day: 4, hour: 21, minute: 11, second: 22).formatted(style: .monthName)
        let apr = Date(year: 2022, month: 4, day: 4, hour: 21, minute: 11, second: 22).formatted(style: .monthName)
        let may = Date(year: 2022, month: 5, day: 4, hour: 21, minute: 11, second: 22).formatted(style: .monthName)
        let jun = Date(year: 2022, month: 6, day: 4, hour: 21, minute: 11, second: 22).formatted(style: .monthName)
        let jul = Date(year: 2022, month: 7, day: 4, hour: 21, minute: 11, second: 22).formatted(style: .monthName)
        let aug = Date(year: 2022, month: 8, day: 4, hour: 21, minute: 11, second: 22).formatted(style: .monthName)
        let sep = Date(year: 2022, month: 9, day: 4, hour: 21, minute: 11, second: 22).formatted(style: .monthName)
        let oct = Date(year: 2022, month: 10, day: 4, hour: 21, minute: 11, second: 22).formatted(style: .monthName)
        let nov = Date(year: 2022, month: 11, day: 4, hour: 21, minute: 11, second: 22).formatted(style: .monthName)
        let dec = Date(year: 2022, month: 12, day: 4, hour: 21, minute: 11, second: 22).formatted(style: .monthName)

        let jan_es = Date(year: 2022, month: 1, day: 31, hour: 23, minute: 59, second: 59, calendar: .spanish).formatted(style: .monthName, in: .spanish)
        let feb_es = Date(year: 2022, month: 2, day: 4, hour: 21, minute: 11, second: 22, calendar: .spanish).formatted(style: .monthName, in: .spanish)
        let mar_es = Date(year: 2022, month: 3, day: 4, hour: 21, minute: 11, second: 22, calendar: .spanish).formatted(style: .monthName, in: .spanish)
        let apr_es = Date(year: 2022, month: 4, day: 4, hour: 21, minute: 11, second: 22, calendar: .spanish).formatted(style: .monthName, in: .spanish)
        let may_es = Date(year: 2022, month: 5, day: 4, hour: 21, minute: 11, second: 22, calendar: .spanish).formatted(style: .monthName, in: .spanish)
        let jun_es = Date(year: 2022, month: 6, day: 4, hour: 21, minute: 11, second: 22, calendar: .spanish).formatted(style: .monthName, in: .spanish)
        let jul_es = Date(year: 2022, month: 7, day: 4, hour: 21, minute: 11, second: 22, calendar: .spanish).formatted(style: .monthName, in: .spanish)
        let aug_es = Date(year: 2022, month: 8, day: 4, hour: 21, minute: 11, second: 22, calendar: .spanish).formatted(style: .monthName, in: .spanish)
        let sep_es = Date(year: 2022, month: 9, day: 4, hour: 21, minute: 11, second: 22, calendar: .spanish).formatted(style: .monthName, in: .spanish)
        let oct_es = Date(year: 2022, month: 10, day: 4, hour: 21, minute: 11, second: 22, calendar: .spanish).formatted(style: .monthName, in: .spanish)
        let nov_es = Date(year: 2022, month: 11, day: 4, hour: 21, minute: 11, second: 22, calendar: .spanish).formatted(style: .monthName, in: .spanish)
        let dec_es = Date(year: 2022, month: 12, day: 4, hour: 21, minute: 11, second: 22, calendar: .spanish).formatted(style: .monthName, in: .spanish)

        #expect(jan == "January")
        #expect(feb == "February")
        #expect(mar == "March")
        #expect(apr == "April")
        #expect(may == "May")
        #expect(jun == "June")
        #expect(jul == "July")
        #expect(aug == "August")
        #expect(sep == "September")
        #expect(oct == "October")
        #expect(nov == "November")
        #expect(dec == "December")

        #expect(jan_es == "enero")
        #expect(feb_es == "febrero")
        #expect(mar_es == "marzo")
        #expect(apr_es == "abril")
        #expect(may_es == "mayo")
        #expect(jun_es == "junio")
        #expect(jul_es == "julio")
        #expect(aug_es == "agosto")
        #expect(sep_es == "septiembre")
        #expect(oct_es == "octubre")
        #expect(nov_es == "noviembre")
        #expect(dec_es == "diciembre")
    }

    @Test
    func formatted_weekdayName() {
        let mon = Date(year: 2020, month: 1, day: 6, hour: 23, minute: 59, second: 59).formatted(style: .weekdayName)
        let tue = Date(year: 2020, month: 1, day: 7, hour: 23, minute: 59, second: 59).formatted(style: .weekdayName)
        let wed = Date(year: 2020, month: 1, day: 8, hour: 23, minute: 59, second: 59).formatted(style: .weekdayName)
        let thu = Date(year: 2020, month: 1, day: 9, hour: 23, minute: 59, second: 59).formatted(style: .weekdayName)
        let fri = Date(year: 2020, month: 1, day: 10, hour: 23, minute: 59, second: 59).formatted(style: .weekdayName)
        let sat = Date(year: 2020, month: 1, day: 11, hour: 23, minute: 59, second: 59).formatted(style: .weekdayName)
        let sun = Date(year: 2020, month: 1, day: 12, hour: 23, minute: 59, second: 59).formatted(style: .weekdayName)

        let mon_es = Date(year: 2020, month: 1, day: 6, hour: 23, minute: 59, second: 59, calendar: .spanish).formatted(style: .weekdayName, in: .spanish)
        let tue_es = Date(year: 2020, month: 1, day: 7, hour: 23, minute: 59, second: 59, calendar: .spanish).formatted(style: .weekdayName, in: .spanish)
        let wed_es = Date(year: 2020, month: 1, day: 8, hour: 23, minute: 59, second: 59, calendar: .spanish).formatted(style: .weekdayName, in: .spanish)
        let thu_es = Date(year: 2020, month: 1, day: 9, hour: 23, minute: 59, second: 59, calendar: .spanish).formatted(style: .weekdayName, in: .spanish)
        let fri_es = Date(year: 2020, month: 1, day: 10, hour: 23, minute: 59, second: 59, calendar: .spanish).formatted(style: .weekdayName, in: .spanish)
        let sat_es = Date(year: 2020, month: 1, day: 11, hour: 23, minute: 59, second: 59, calendar: .spanish).formatted(style: .weekdayName, in: .spanish)
        let sun_es = Date(year: 2020, month: 1, day: 12, hour: 23, minute: 59, second: 59, calendar: .spanish).formatted(style: .weekdayName, in: .spanish)

        #expect(mon == "Monday")
        #expect(tue == "Tuesday")
        #expect(wed == "Wednesday")
        #expect(thu == "Thursday")
        #expect(fri == "Friday")
        #expect(sat == "Saturday")
        #expect(sun == "Sunday")

        #expect(mon_es == "lunes")
        #expect(tue_es == "martes")
        #expect(wed_es == "miércoles")
        #expect(thu_es == "jueves")
        #expect(fri_es == "viernes")
        #expect(sat_es == "sábado")
        #expect(sun_es == "domingo")
    }

    @Test
    func formatted_weekdayNameFromIndex() {
        #expect(Date.weekdayName(for: 1) == "Sunday")
        #expect(Date.weekdayName(for: 2) == "Monday")
        #expect(Date.weekdayName(for: 3) == "Tuesday")
        #expect(Date.weekdayName(for: 4) == "Wednesday")
        #expect(Date.weekdayName(for: 5) == "Thursday")
        #expect(Date.weekdayName(for: 6) == "Friday")
        #expect(Date.weekdayName(for: 7) == "Saturday")

        #expect(Date.weekdayName(for: 1, in: .spanish) == "domingo")
        #expect(Date.weekdayName(for: 2, in: .spanish) == "lunes")
        #expect(Date.weekdayName(for: 3, in: .spanish) == "martes")
        #expect(Date.weekdayName(for: 4, in: .spanish) == "miércoles")
        #expect(Date.weekdayName(for: 5, in: .spanish) == "jueves")
        #expect(Date.weekdayName(for: 6, in: .spanish) == "viernes")
        #expect(Date.weekdayName(for: 7, in: .spanish) == "sábado")
    }

    @Test
    func dateUnit() {
        let date = Date(year: 2022, month: 2, day: 1, hour: 3, minute: 41, second: 22)

        #expect(2022 == date.component(.year))
        #expect(2 == date.component(.month))
        #expect(1 == date.component(.day))
        #expect(3 == date.component(.hour))
        #expect(41 == date.component(.minute))
        #expect(22 == date.component(.second))

        // Test in different calendar.
        #expect(2022 == date.component(.year, in: .usEastern))
        #expect(1 == date.component(.month, in: .usEastern))
        #expect(31 == date.component(.day, in: .usEastern))
        #expect(22 == date.component(.hour, in: .usEastern))
        #expect(41 == date.component(.minute, in: .usEastern))
        #expect(22 == date.component(.second, in: .usEastern))
    }

    @Test
    func isSameDate() {
        let testYearGranularityDateLeft = Date(year: 2022, month: 4, day: 5, hour: 1, minute: 45, second: 33)
        let testYearGranularityDateRight = Date(year: 2022, month: 2, day: 1, hour: 3, minute: 41, second: 22)

        let testMonthGranularityDateLeft = Date(year: 2022, month: 4, day: 5, hour: 1, minute: 45, second: 33)
        let testMonthGranularityDateRight = Date(year: 2022, month: 4, day: 1, hour: 3, minute: 41, second: 22)

        let testDayGranularityDateLeft = Date(year: 2022, month: 4, day: 5, hour: 1, minute: 45, second: 33)
        let testDayGranularityDateRight = Date(year: 2022, month: 4, day: 5, hour: 3, minute: 41, second: 22)

        let testHourGranularityDateLeft = Date(year: 2022, month: 4, day: 5, hour: 1, minute: 45, second: 33)
        let testHourGranularityDateRight = Date(year: 2022, month: 4, day: 5, hour: 1, minute: 41, second: 22)

        let testMinuteGranularityDateLeft = Date(year: 2022, month: 4, day: 5, hour: 1, minute: 45, second: 33)
        let testMinuteGranularityDateRight = Date(year: 2022, month: 4, day: 5, hour: 1, minute: 45, second: 22)

        let testSecondsGranularityDateLeft = Date(year: 2022, month: 4, day: 5, hour: 1, minute: 45, second: 33)
        let testSecondsGranularityDateRight = Date(year: 2022, month: 4, day: 5, hour: 1, minute: 45, second: 33)

        let testMultipleCalendarDateLeft = Date(year: 2022, month: 4, day: 5, hour: 1, minute: 45, second: 33, calendar: .iso)
        let testMultipleCalendarDateRight = Date(year: 2022, month: 4, day: 4, hour: 21, minute: 45, second: 33, calendar: .usEastern)

        #expect(testYearGranularityDateLeft.isSame(testYearGranularityDateRight, granularity: .year), "Year granularity failed")
        #expect(testMonthGranularityDateLeft.isSame(testMonthGranularityDateRight, granularity: .month), "Month granularity failed")
        #expect(testDayGranularityDateLeft.isSame(testDayGranularityDateRight, granularity: .day), "Day granularity failed")
        #expect(testHourGranularityDateLeft.isSame(testHourGranularityDateRight, granularity: .hour), "Hour granularity failed")
        #expect(testMinuteGranularityDateLeft.isSame(testMinuteGranularityDateRight, granularity: .minute), "Minute granularity failed")
        #expect(testSecondsGranularityDateLeft.isSame(testSecondsGranularityDateRight, granularity: .second), "Seconds granularity failed")
        #expect(testSecondsGranularityDateLeft.isSame(testSecondsGranularityDateRight, granularity: .nanosecond), "NanoSeconds granularity failed")
        #expect(testMultipleCalendarDateLeft.isSame(testMultipleCalendarDateRight, granularity: .second), "Multi calendar test failed")
    }

    @Test
    func isPastDate() {
        let testYearGranularityDateLeft = Date(year: 2019, month: 4, day: 5, hour: 1, minute: 45, second: 33)
        let testYearGranularityDateRight = Date(year: 2022, month: 2, day: 1, hour: 3, minute: 41, second: 22)

        let testMonthGranularityDateLeft = Date(year: 2022, month: 3, day: 5, hour: 1, minute: 45, second: 33)
        let testMonthGranularityDateRight = Date(year: 2022, month: 4, day: 1, hour: 3, minute: 41, second: 22)

        let testDayGranularityDateLeft = Date(year: 2022, month: 4, day: 3, hour: 1, minute: 45, second: 33)
        let testDayGranularityDateRight = Date(year: 2022, month: 4, day: 5, hour: 3, minute: 41, second: 22)

        let testHourGranularityDateLeft = Date(year: 2022, month: 4, day: 5, hour: 0, minute: 45, second: 33)
        let testHourGranularityDateRight = Date(year: 2022, month: 4, day: 5, hour: 1, minute: 41, second: 22)

        let testMinuteGranularityDateLeft = Date(year: 2022, month: 4, day: 5, hour: 1, minute: 44, second: 33)
        let testMinuteGranularityDateRight = Date(year: 2022, month: 4, day: 5, hour: 1, minute: 45, second: 22)

        let testSecondsGranularityDateLeft = Date(year: 2022, month: 4, day: 5, hour: 1, minute: 45, second: 11)
        let testSecondsGranularityDateRight = Date(year: 2022, month: 4, day: 5, hour: 1, minute: 45, second: 33)

        let testMultipleCalendarDateLeft = Date(year: 2022, month: 4, day: 5, hour: 1, minute: 45, second: 33, calendar: .iso)
        let testMultipleCalendarDateRight = Date(year: 2022, month: 4, day: 4, hour: 21, minute: 46, second: 33, calendar: .usEastern)

        #expect(testYearGranularityDateLeft.isBefore(testYearGranularityDateRight, granularity: .year), "Year granularity failed")
        #expect(testMonthGranularityDateLeft.isBefore(testMonthGranularityDateRight, granularity: .month), "Month granularity failed")
        #expect(testDayGranularityDateLeft.isBefore(testDayGranularityDateRight, granularity: .day), "Day granularity failed")
        #expect(testHourGranularityDateLeft.isBefore(testHourGranularityDateRight, granularity: .hour), "Hour granularity failed")
        #expect(testMinuteGranularityDateLeft.isBefore(testMinuteGranularityDateRight, granularity: .minute), "Minute granularity failed")
        #expect(testSecondsGranularityDateLeft.isBefore(testSecondsGranularityDateRight, granularity: .second), "Seconds granularity failed")
        #expect(testSecondsGranularityDateLeft.isBefore(testSecondsGranularityDateRight, granularity: .nanosecond), "NanoSeconds granularity failed")
        #expect(testMultipleCalendarDateLeft.isBefore(testMultipleCalendarDateRight, granularity: .second), "Multi calendar test failed")
    }

    @Test
    func isFutureDate() {
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

        #expect(testYearGranularityDateLeft.isAfter(testYearGranularityDateRight, granularity: .year), "Year granularity failed")
        #expect(testMonthGranularityDateLeft.isAfter(testMonthGranularityDateRight, granularity: .month), "Month granularity failed")
        #expect(testDayGranularityDateLeft.isAfter(testDayGranularityDateRight, granularity: .day), "Day granularity failed")
        #expect(testHourGranularityDateLeft.isAfter(testHourGranularityDateRight, granularity: .hour), "Hour granularity failed")
        #expect(testMinuteGranularityDateLeft.isAfter(testMinuteGranularityDateRight, granularity: .minute), "Minute granularity failed")
        #expect(testSecondsGranularityDateLeft.isAfter(testSecondsGranularityDateRight, granularity: .second), "Seconds granularity failed")
        #expect(testSecondsGranularityDateLeft.isAfter(testSecondsGranularityDateRight, granularity: .nanosecond), "NanoSeconds granularity failed")
        #expect(testMultipleCalendarDateLeft.isAfter(testMultipleCalendarDateRight, granularity: .second), "Multi calendar test failed")
    }

    @Test
    func isAfterDate_seconds() async throws {
        let pastDate = Date(year: 2021, month: 4, day: 5, hour: 1, minute: 45, second: 33)
        #expect(pastDate.isAfter(duration: 30) == true)

        let futureDate = Date().adjusting(.second, by: 31)
        #expect(futureDate.isAfter(duration: 32) == true)
        #expect(futureDate.isAfter(duration: 31) == false)
        #expect(futureDate.isAfter(duration: 30) == false)
        // sleep for 1 second so we can validate it indeed is after
        try await Task.sleep(for: .seconds(1))
        #expect(futureDate.isAfter(duration: 31) == true)
    }

    @Test
    func isBetweenDate() {
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

        #expect(testYearGranularityDateMid.isBetween(testYearGranularityDateInterval, granularity: .year), "Year granularity failed")
        #expect(testMonthGranularityDateMid.isBetween(testMonthGranularityDateInterval, granularity: .month), "Month granularity failed")
        #expect(testDayGranularityDateMid.isBetween(testDayGranularityDateInterval, granularity: .day), "Day granularity failed")
        #expect(testHourGranularityDateMid.isBetween(testHourGranularityDateInterval, granularity: .hour), "Hour granularity failed")
        #expect(testMinuteGranularityDateMid.isBetween(testMinuteGranularityDateInterval, granularity: .minute), "Minute granularity failed")
        #expect(testSecondsGranularityDateMid.isBetween(testSecondsGranularityDateInterval, granularity: .second), "Seconds granularity failed")
        #expect(testSecondsGranularityDateMid.isBetween(testSecondsGranularityDateInterval, granularity: .nanosecond), "NanoSeconds granularity failed")
        #expect(testMultipleCalendarDateMid.isBetween(testMultipleCalendarDateInterval, granularity: .second), "Multi calendar test failed")
    }

    @Test
    func numberOf() {
        let date = Date(year: 2019, month: 3, day: 4, hour: 2, minute: 22, second: 44)
        let anotherDate = Date(year: 2020, month: 4, day: 5, hour: 1, minute: 45, second: 55)
        #expect(1 == date.numberOf(.year, to: anotherDate))
        #expect(13 == date.numberOf(.month, to: anotherDate))
        #expect(56 == date.numberOf(.weekOfYear, to: anotherDate))
        #expect(397 == date.numberOf(.day, to: anotherDate))
        #expect(9551 == date.numberOf(.hour, to: anotherDate))
        #expect(573_083 == date.numberOf(.minute, to: anotherDate))
        #expect(34_384_991 == date.numberOf(.second, to: anotherDate))
    }

    @Test
    func timeInDifferentCalendar() {
        let expectedHour = 17
        let date = Date(year: 2022, month: 5, day: 4, hour: 21, minute: 11, second: 22)
        let receivedHour = date.component(.hour, in: .usEastern)
        #expect(expectedHour == receivedHour)
    }

    @Test
    func dateAdjustments() {
        let expectedDate = Date(year: 2021, month: 9, day: 1, hour: 21, minute: 11, second: 22)
        let dateToAdjust = Date(year: 2022, month: 5, day: 4, hour: 21, minute: 11, second: 22)
        let adjustedDate = dateToAdjust
            .adjusting(.year, by: -1)
            .adjusting(.month, by: 4)
            .adjusting(.day, by: -3)
        #expect(expectedDate == adjustedDate)
    }

    @Test
    func startOfDate() {
        let components: [Calendar.Component] = [.year, .month, .day, .hour, .minute]
        let dateToAdjust = Date(year: 2022, month: 5, day: 4, hour: 21, minute: 11, second: 22)

        for component in components {
            let expectedDate: Date

            switch component {
                case .year:
                    expectedDate = Date(year: 2022, month: 1, day: 1, hour: 0, minute: 0, second: 0)
                case .month:
                    expectedDate = Date(year: 2022, month: 5, day: 1, hour: 0, minute: 0, second: 0)
                case .day:
                    expectedDate = Date(year: 2022, month: 5, day: 4, hour: 0, minute: 0, second: 0)
                case .hour:
                    expectedDate = Date(year: 2022, month: 5, day: 4, hour: 21, minute: 0, second: 0)
                case .minute:
                    expectedDate = Date(year: 2022, month: 5, day: 4, hour: 21, minute: 11, second: 0)
                default:
                    expectedDate = Date()
                    Issue.record("Unexpected test case")
            }

            let startOfDate = dateToAdjust.startOf(component)
            print("Expected Date = \(expectedDate)")
            print("Receieved Result = \(startOfDate)")
            #expect(expectedDate == startOfDate)
        }
    }

    @Test
    func startOfDate_Calendar() {
        let expectedDate = Date(year: 2022, month: 1, day: 1, calendar: .current)
        let adjustedDate = expectedDate.startOf(.month, in: .current)
        #expect(expectedDate == adjustedDate)
    }

    @Test
    func endOfDate() {
        let components: [Calendar.Component] = [.year, .month, .day, .hour, .minute]
        let dateToAdjust = Date(year: 2022, month: 5, day: 4, hour: 21, minute: 11, second: 22)

        for component in components {
            let expectedDate: Date

            switch component {
                case .year:
                    expectedDate = Date(year: 2022, month: 12, day: 31, hour: 23, minute: 59, second: 59).addingTimeInterval(0.999)
                case .month:
                    expectedDate = Date(year: 2022, month: 5, day: 31, hour: 23, minute: 59, second: 59).addingTimeInterval(0.999)
                case .day:
                    expectedDate = Date(year: 2022, month: 5, day: 4, hour: 23, minute: 59, second: 59).addingTimeInterval(0.999)
                case .hour:
                    expectedDate = Date(year: 2022, month: 5, day: 4, hour: 21, minute: 59, second: 59).addingTimeInterval(0.999)
                case .minute:
                    expectedDate = Date(year: 2022, month: 5, day: 4, hour: 21, minute: 11, second: 59).addingTimeInterval(0.999)
                default:
                    expectedDate = Date()
                    Issue.record("Unexpected test case")
            }

            let endOfDate = dateToAdjust.endOf(component)
            #expect(expectedDate == endOfDate)
        }
    }

    @Test
    func totalDaysInMonth() {
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

        #expect(jan.monthDays() == 31)
        #expect(leapYearFeb.monthDays() == 29)
        #expect(nonLeapYearFeb.monthDays() == 28)
        #expect(mar.monthDays() == 31)
        #expect(apr.monthDays() == 30)
        #expect(may.monthDays() == 31)
        #expect(jun.monthDays() == 30)
        #expect(jul.monthDays() == 31)
        #expect(aug.monthDays() == 31)
        #expect(sep.monthDays() == 30)
        #expect(oct.monthDays() == 31)
        #expect(nov.monthDays() == 30)
        #expect(dec.monthDays() == 31)
    }

    @Test
    func adjustmentWithDateComponents() {
        let dateToAdjust = Date(year: 2020, month: 3, day: 1, hour: 3, minute: 41, second: 22)
        var dateComponents = DateComponents()
        dateComponents.year = 1
        dateComponents.month = -2
        dateComponents.day = 3

        let expectedResult = Date(year: 2021, month: 1, day: 4, hour: 3, minute: 41, second: 22)
        #expect(expectedResult == dateToAdjust.adjusting(dateComponents))
    }

    @Test
    func comparisonOperatorDay() {
        let today = Date()
        #expect(today.is(.today))
        #expect(!today.is(.tomorrow))
        #expect(!today.is(.yesterday))

        let tomorrow = Date().adjusting(.day, by: 1)
        #expect(!tomorrow.is(.today))
        #expect(tomorrow.is(.tomorrow))
        #expect(!tomorrow.is(.yesterday))

        let yesterday = Date().adjusting(.day, by: -1)
        #expect(!yesterday.is(.today))
        #expect(!yesterday.is(.tomorrow))
        #expect(yesterday.is(.yesterday))

        let date = Date(year: 3020, month: 2, day: 1, hour: 3, minute: 41, second: 22)
        #expect(!date.is(.yesterday))
        #expect(!date.is(.today))
        #expect(!date.is(.tomorrow))
    }

    @Test
    func comparisonOperatorNext() {
        let now = Date()
        let previousDate = Date(year: 3020, month: 2, day: 1, hour: 3, minute: 41, second: 22)

        let futureDate_Day = now.adjusting(.day, by: 10)
        let nextDate_Day = now.adjusting(.day, by: 1)
        let nextDate_Weekday = now.adjusting(.weekday, by: 1)
        let nextDate_Month = now.adjusting(.month, by: 1)
        let nextDate_Year = now.adjusting(.year, by: 1)

        #expect(!previousDate.is(.next(.day)))
        #expect(!previousDate.is(.next(.weekday)))
        #expect(!previousDate.is(.next(.month)))
        #expect(!previousDate.is(.next(.year)))

        #expect(!futureDate_Day.is(.tomorrow), "Expected \(futureDate_Day.component(.day)) to not be tomorrow.")
        #expect(nextDate_Day.is(.tomorrow), "Expected \(nextDate_Day.component(.day)) to be tomorrow.")
        #expect(nextDate_Day.is(.next(.day)), "Expected \(nextDate_Day.component(.day)) to be next day after \(now.component(.day)).")
        #expect(nextDate_Weekday.is(.next(.weekday)), "Expected \(nextDate_Weekday.component(.weekday)) to be next weekday after \(now.component(.weekday)).")
        #expect(nextDate_Month.is(.next(.month)), "Expected \(nextDate_Month.component(.month)) to be next month after \(now.component(.month)).")
        #expect(nextDate_Year.is(.next(.year)), "Expected \(nextDate_Year.component(.year)) to be next year after \(now.component(.year)).")
    }

    @Test
    func comparisonOperatorPrevious() {
        let now = Date()
        let nextDate = Date(year: 3020, month: 2, day: 1, hour: 3, minute: 41, second: 22)

        let pastDate_Day = now.adjusting(.day, by: -10)
        let previousDate_Day = now.adjusting(.day, by: -1)
        let previousDate_Weekday = now.adjusting(.weekday, by: -1)
        let previousDate_Month = now.adjusting(.month, by: -1)
        let previousDate_Year = now.adjusting(.year, by: -1)

        #expect(!nextDate.is(.previous(.day)))
        #expect(!nextDate.is(.previous(.weekday)))
        #expect(!nextDate.is(.previous(.month)))
        #expect(!nextDate.is(.previous(.year)))

        #expect(!pastDate_Day.is(.yesterday), "Expected \(pastDate_Day.component(.day)) to not be yesterday.")
        #expect(previousDate_Day.is(.yesterday), "Expected \(previousDate_Day.component(.day)) to be yesterday.")
        #expect(previousDate_Day.is(.previous(.day)), "Expected \(previousDate_Day.component(.day)) to be a day before \(now.component(.day)).")
        #expect(previousDate_Weekday.is(.previous(.weekday)), "Expected \(previousDate_Weekday.component(.weekday)) to be a weekday \(now.component(.weekday)).")
        #expect(previousDate_Month.is(.previous(.month)), "Expected \(previousDate_Month.component(.month)) to be a month before \(now.component(.month)).")
        #expect(previousDate_Year.is(.previous(.year)), "Expected \(previousDate_Year.component(.year)) to be a year before \(now.component(.year)).")
    }

    @Test
    func comparisonOperatorPast() {
        let now = Date()
        let nextDate = Date(year: 3020, month: 2, day: 1, hour: 3, minute: 41, second: 22)
        let previousDate = Date(year: 1020, month: 2, day: 1, hour: 3, minute: 41, second: 22)

        let pastDate_Day = now.adjusting(.day, by: -10)
        let pastDate_Weekday = now.adjusting(.weekday, by: -10)
        let pastDate_Month = now.adjusting(.month, by: -10)
        let pastDate_Year = now.adjusting(.year, by: -10)

        #expect(!nextDate.is(.past(.day)))
        #expect(!nextDate.is(.past(.weekday)))
        #expect(!nextDate.is(.past(.month)))
        #expect(!nextDate.is(.past(.year)))

        #expect(previousDate.is(.past(.day)))
        #expect(previousDate.is(.past(.weekday)))
        #expect(previousDate.is(.past(.month)))
        #expect(previousDate.is(.past(.year)))

        #expect(pastDate_Day.is(.past(.day)), "Expected \(pastDate_Day.component(.day)) to be day past \(now.component(.day)).")
        #expect(pastDate_Weekday.is(.past(.weekday)), "Expected \(pastDate_Weekday.component(.weekday)) to be weekday past \(now.component(.weekday)).")
        #expect(pastDate_Month.is(.past(.month)), "Expected \(pastDate_Month.component(.month)) to be month past \(now.component(.month)).")
        #expect(pastDate_Year.is(.past(.year)), "Expected \(pastDate_Year.component(.year)) to be year past \(now.component(.year)).")
    }

    @Test
    func comparisonOperatorFuture() {
        let now = Date()
        let nextDate = Date(year: 3020, month: 2, day: 1, hour: 3, minute: 41, second: 22)
        let previousDate = Date(year: 1020, month: 2, day: 1, hour: 3, minute: 41, second: 22)

        let futureDate_Day = now.adjusting(.day, by: 10)
        let futureDate_Weekday = now.adjusting(.weekday, by: 10)
        let futureDate_Month = now.adjusting(.month, by: 10)
        let futureDate_Year = now.adjusting(.year, by: 10)

        #expect(nextDate.is(.future(.day)))
        #expect(nextDate.is(.future(.weekday)))
        #expect(nextDate.is(.future(.month)))
        #expect(nextDate.is(.future(.year)))

        #expect(!previousDate.is(.future(.day)))
        #expect(!previousDate.is(.future(.weekday)))
        #expect(!previousDate.is(.future(.month)))
        #expect(!previousDate.is(.future(.year)))

        #expect(futureDate_Day.is(.future(.day)), "Expected \(futureDate_Day.component(.day)) to be day future \(now.component(.day)).")
        #expect(futureDate_Weekday.is(.future(.weekday)), "Expected \(futureDate_Weekday.component(.weekday)) to be weekday future \(now.component(.weekday)).")
        #expect(futureDate_Month.is(.future(.month)), "Expected \(futureDate_Month.component(.month)) to be month future \(now.component(.month)).")
        #expect(futureDate_Year.is(.future(.year)), "Expected \(futureDate_Year.component(.year)) to be year future \(now.component(.year)).")
    }

    @Test
    func comparisonOperatorCurrent() {
        let now = Date()
        let nextDate = Date(year: 3020, month: 2, day: 1, hour: 3, minute: 41, second: 22)
        let previousDate = Date(year: 1020, month: 2, day: 1, hour: 3, minute: 41, second: 22)

        let currentDate_Day = now
        let currentDate_Weekday = now
        let currentDate_Month = now
        let currentDate_Year = now

        #expect(!nextDate.is(.current(.day)))
        #expect(!nextDate.is(.current(.weekday)))
        #expect(!nextDate.is(.current(.month)))
        #expect(!nextDate.is(.current(.year)))

        #expect(!previousDate.is(.current(.day)))
        #expect(!previousDate.is(.current(.weekday)))
        #expect(!previousDate.is(.current(.month)))
        #expect(!previousDate.is(.current(.year)))

        #expect(currentDate_Day.is(.current(.day)), "Expected \(currentDate_Day.component(.day)) to be day current \(now.component(.day)).")
        #expect(currentDate_Weekday.is(.current(.weekday)), "Expected \(currentDate_Weekday.component(.weekday)) to be weekday current \(now.component(.weekday)).")
        #expect(currentDate_Month.is(.current(.month)), "Expected \(currentDate_Month.component(.month)) to be month current \(now.component(.month)).")
        #expect(currentDate_Year.is(.current(.year)), "Expected \(currentDate_Year.component(.year)) to be year current \(now.component(.year)).")
    }

    @Test
    func comparisonOperatorWeekend() {
        let nonWeekend = Date(year: 2000, month: 1, day: 3)
        #expect(!nonWeekend.is(.weekend))

        let weekend = Date(year: 2000, month: 1, day: 1)
        #expect(weekend.is(.weekend))
    }

    @Test
    func dateIntervalsStaticDates() {
        // Week
        let thisWeekStartDate = Date(year: 2020, month: 1, day: 5, hour: 0, minute: 0, second: 0)
        let thisWeekEndDate = Date(year: 2020, month: 1, day: 11, hour: 23, minute: 59, second: 59)
        let thisWeek = thisWeekStartDate.interval(for: .weekOfYear)
        #expect(thisWeek.start == thisWeekStartDate, "Expected \(thisWeek.start) to equal \(thisWeekStartDate)")
        #expect(thisWeek.end.removingMilliseconds() == thisWeekEndDate, "Expected \(thisWeek.end) to equal \(thisWeekEndDate)")

        let lastWeekStartDate = Date(year: 2019, month: 12, day: 29, hour: 0, minute: 0, second: 0)
        let lastWeekEndDate = Date(year: 2020, month: 1, day: 4, hour: 23, minute: 59, second: 59)
        let lastWeek = thisWeekStartDate.interval(for: .weekOfYear, adjustedBy: -1)
        #expect(lastWeek.start == lastWeekStartDate, "Expected \(lastWeek.start) to equal \(lastWeekStartDate)")
        #expect(lastWeek.end.removingMilliseconds() == lastWeekEndDate, "Expected \(lastWeek.end) to equal \(lastWeekEndDate)")

        // Month
        let thisMonthStartDate = Date(year: 2020, month: 2, day: 1, hour: 0, minute: 0, second: 0)
        let thisMonthEndDate = Date(year: 2020, month: 2, day: 29, hour: 23, minute: 59, second: 59)
        let thisMonth = thisMonthStartDate.interval(for: .month)
        #expect(thisMonth.start == thisMonthStartDate, "Expected \(thisMonth.start) to equal \(thisMonthStartDate)")
        #expect(thisMonth.end.removingMilliseconds() == thisMonthEndDate, "Expected \(thisMonth.end) to equal \(thisMonthEndDate)")

        let lastMonthStartDate = Date(year: 2020, month: 1, day: 1, hour: 0, minute: 0, second: 0)
        let lastMonthEndDate = Date(year: 2020, month: 1, day: 31, hour: 23, minute: 59, second: 59)
        let lastMonth = thisMonthStartDate.interval(for: .month, adjustedBy: -1)
        #expect(lastMonth.start == lastMonthStartDate, "Expected \(lastMonth.start) to equal \(lastMonthStartDate)")
        #expect(lastMonth.end.removingMilliseconds() == lastMonthEndDate, "Expected \(lastMonth.end) to equal \(lastMonthEndDate)")

        // Year
        let thisYearStartDate = Date(year: 2020, month: 1, day: 1, hour: 0, minute: 0, second: 0)
        let thisYearEndDate = Date(year: 2020, month: 12, day: 31, hour: 23, minute: 59, second: 59)
        let thisYear = thisYearStartDate.interval(for: .year)
        #expect(thisYear.start == thisYearStartDate, "Expected \(thisYear.start) to equal \(thisYearStartDate)")
        #expect(thisYear.end.removingMilliseconds() == thisYearEndDate, "Expected \(thisYear.end) to equal \(thisYearEndDate)")

        let lastYearStartDate = Date(year: 2019, month: 1, day: 1, hour: 0, minute: 0, second: 0)
        let lastYearEndDate = Date(year: 2019, month: 12, day: 31, hour: 23, minute: 59, second: 59)
        let lastYear = thisYearStartDate.interval(for: .year, adjustedBy: -1)
        #expect(lastYear.start == lastYearStartDate, "Expected \(lastYear.start) to equal \(lastYearStartDate)")
        #expect(lastYear.end.removingMilliseconds() == lastYearEndDate, "Expected \(lastYear.end) to equal \(lastYearEndDate)")
    }

    @Test
    func dateIntervalBulk() {
        let components: [Calendar.Component] = [
            .weekOfYear,
            .month,
            .year
        ]

        // Current
        for component in components {
            let interval = Date().interval(for: component)
            let date = Date().startOf(component)
            #expect(interval.start == date)
            #expect(interval.end == date.endOf(component))
        }

        // Previous
        for component in components {
            let interval = Date().interval(for: component, adjustedBy: -1)
            let date = Date().startOf(component).adjusting(component, by: -1)
            #expect(interval.start == date)
            #expect(interval.end == date.endOf(component))
        }
    }

    @Test
    func dateIntervalLiveDates() {
        // Week
        let lastWeek = DateInterval.lastWeek
        #expect(lastWeek.start == Date().startOf(.weekOfYear).adjusting(.weekOfYear, by: -1))
        #expect(lastWeek.end == Date().startOf(.weekOfYear).adjusting(.weekOfYear, by: -1).endOf(.weekOfYear))

        let thisWeek = DateInterval.thisWeek
        #expect(thisWeek.start == Date().startOf(.weekOfYear))
        #expect(thisWeek.end == Date().endOf(.weekOfYear))

        // Month
        let lastMonth = DateInterval.lastMonth
        #expect(lastMonth.start == Date().startOf(.month).adjusting(.month, by: -1))
        #expect(lastMonth.end == Date().startOf(.month).adjusting(.month, by: -1).endOf(.month))

        let thisMonth = DateInterval.thisMonth
        #expect(thisMonth.start == Date().startOf(.month))
        #expect(thisMonth.end == Date().endOf(.month))

        // Year
        let lastYear = DateInterval.lastYear
        #expect(lastYear.start == Date().startOf(.year).adjusting(.year, by: -1))
        #expect(lastYear.end == Date().startOf(.year).adjusting(.year, by: -1).endOf(.year))

        let thisYear = DateInterval.thisYear
        #expect(thisYear.start == Date().startOf(.year))
        #expect(thisYear.end == Date().endOf(.year))
    }

    @Test
    func startOf_removingTime() {
        let date = Date(year: 2022, month: 5, day: 4, hour: 21, minute: 11, second: 22)
        let expectedDate = Date(year: 2022, month: 5, day: 4)

        #expect(date.startOf(.day) == expectedDate)
        #expect(date.removingTime() == expectedDate)
        #expect(date.startOf(.day) == date.removingTime())

        let now = Date()
        let nowExpectedDate = Date(year: now.component(.year), month: now.component(.month), day: now.component(.day))
        #expect(now.startOf(.day) == nowExpectedDate)
        #expect(now.removingTime() == nowExpectedDate)
        #expect(now.startOf(.day) == now.removingTime())
    }

    @Test
    func startOf_removingTime_current_calendar() {
        let date = Date(year: 2022, month: 5, day: 4, hour: 21, minute: 11, second: 22, calendar: .current)
        let expectedDate = Date(year: 2022, month: 5, day: 4, calendar: .current)

        #expect(date.startOf(.day, in: .current) == expectedDate)
        #expect(date.removingTime(calendar: .current) == expectedDate)
        #expect(date.startOf(.day, in: .current) == date.removingTime(calendar: .current))

        let now = Date()
        let nowExpectedDate = Date(
            year: now.component(.year, in: .current),
            month: now.component(.month, in: .current),
            day: now.component(.day, in: .current),
            calendar: .current
        )
        #expect(now.startOf(.day, in: .current) == nowExpectedDate)
        #expect(now.removingTime(calendar: .current) == nowExpectedDate)
        #expect(now.startOf(.day, in: .current) == now.removingTime(calendar: .current))
    }

    @Test
    func startOf_removingTime_current_calendar_with() {
        let date = Date(year: 2022, month: 5, day: 4, hour: 21, minute: 11, second: 22, calendar: .current)
        let expectedDate = Date(year: 2022, month: 5, day: 4, calendar: .current)

        Date.withCalendar(.current) {
            #expect(date.startOf(.day) == expectedDate)
            #expect(date.removingTime() == expectedDate)
            #expect(date.startOf(.day) == date.removingTime())

            let now = Date()
            let nowExpectedDate = Date(
                year: now.component(.year),
                month: now.component(.month),
                day: now.component(.day)
            )
            #expect(now.startOf(.day) == nowExpectedDate)
            #expect(now.removingTime() == nowExpectedDate)
            #expect(now.startOf(.day) == now.removingTime())
        }
    }

    @Test
    func timeZone() {
        #expect(Date.timeZoneOffset(calendar: .usEastern) == -5)
        #expect(Date.timeZoneOffset(calendar: .iso) == 0)
        #expect(Date.timeZoneOffset(calendar: .turkey) == 3)
    }
}

extension Calendar {
    fileprivate static let spanish = Self.gregorian(timeZone: .utc, locale: .es)
    fileprivate static let turkey = Self.gregorian(timeZone: .istanbul, locale: .tr)
    fileprivate static let london = Self.gregorian(timeZone: .london, locale: .uk)
    fileprivate static let usEastern = Self.gregorian(timeZone: .eastern)
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
    /// Returns `self` with time reset to the beginning of the day (`12:00 AM`).
    ///
    /// - Parameter calendar: The calendar to use for the date.
    fileprivate func removingTime(calendar: Calendar = .default) -> Date {
        let components = calendar.dateComponents([.year, .month, .day], from: self)
        return calendar.date(from: components) ?? self
    }

    /// Returns `self` with milliseconds reset to zero.
    ///
    /// - Parameter calendar: The calendar to use for the date.
    fileprivate func removingMilliseconds(calendar: Calendar = .default) -> Date {
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
        return calendar.date(from: components) ?? self
    }
}
