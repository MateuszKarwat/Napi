//
//  Created by Mateusz Karwat on 03/08/16.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

import XCTest
@testable import Napi

class SubtitleConverterModificationTests: XCTestCase {

    func testInitWithCorrectInput() {
        // Time Based format.
        let mpl2Subtitles = "[1][9999]Test."
        let converterTimeBasedInput = try? SubtitleConverter(subtitles: mpl2Subtitles)

        XCTAssertEqual(converterTimeBasedInput?.decodedSubtitles.count, 1)
        XCTAssertEqual(converterTimeBasedInput?.detectedSubtitleFormat, .mpl2)

        XCTAssertEqual(converterTimeBasedInput?.decodedSubtitles[0].startTimestamp.baseValue, 100)
        XCTAssertEqual(converterTimeBasedInput?.decodedSubtitles[0].stopTimestamp.baseValue, 999_900)
        XCTAssertEqual(converterTimeBasedInput?.decodedSubtitles[0].text, "Test.")

        // Frame Based format.
        let microDVDSubtitles = "{0}{100}Test"
        let converterFrameBasedInput = try? SubtitleConverter(subtitles: microDVDSubtitles)

        XCTAssertEqual(converterFrameBasedInput?.decodedSubtitles.count, 1)
        XCTAssertEqual(converterFrameBasedInput?.detectedSubtitleFormat, .microDVD)

        XCTAssertEqual(converterFrameBasedInput?.decodedSubtitles[0].startTimestamp.baseValue, 0)
        XCTAssertEqual(converterFrameBasedInput?.decodedSubtitles[0].stopTimestamp.baseValue, 100_000)
        XCTAssertEqual(converterFrameBasedInput?.decodedSubtitles[0].text, "Test")
    }

    func testInitWithIncorrectInput() {
        do {
            let _ = try SubtitleConverter(subtitles: "It's not a subtitle format")
        } catch let error as SubtitleConvertionError {
            XCTAssertEqual(error, .subtitleFormatNotSupported)
        } catch {
            XCTFail("SubtitleConvertionError has not been thrown.")
        }
    }

    func testOffset() {
        // Positive offset.
        var subtitleConverter = try! SubtitleConverter(subtitles: "01:01:01:Text.")
        subtitleConverter.frameRate = 1.0
        subtitleConverter.offset = 1000 // 1 second
        XCTAssertEqual(try! subtitleConverter.convert(to: .mpl2), "[36620][36670]Text.")
        XCTAssertEqual(try! subtitleConverter.convert(to: .microDVD), "{3662}{3667}Text.")
        XCTAssertEqual(try! subtitleConverter.convert(to: .subRip), "1\n01:01:02,000 --> 01:01:07,000\nText.\n")
        XCTAssertEqual(try! subtitleConverter.convert(to: .tmplayer), "01:01:02:Text.")

        subtitleConverter.offset = 1300 // 1.3 second
        XCTAssertEqual(try! subtitleConverter.convert(to: .mpl2), "[36623][36673]Text.")
        XCTAssertEqual(try! subtitleConverter.convert(to: .microDVD), "{3662}{3667}Text.")
        XCTAssertEqual(try! subtitleConverter.convert(to: .subRip), "1\n01:01:02,300 --> 01:01:07,300\nText.\n")
        XCTAssertEqual(try! subtitleConverter.convert(to: .tmplayer), "01:01:02:Text.")

        subtitleConverter.offset = 60_000 // 60 seconds
        XCTAssertEqual(try! subtitleConverter.convert(to: .mpl2), "[37210][37260]Text.")
        XCTAssertEqual(try! subtitleConverter.convert(to: .microDVD), "{3721}{3726}Text.")
        XCTAssertEqual(try! subtitleConverter.convert(to: .subRip), "1\n01:02:01,000 --> 01:02:06,000\nText.\n")
        XCTAssertEqual(try! subtitleConverter.convert(to: .tmplayer), "01:02:01:Text.")

        subtitleConverter.offset = 3_600_000 // 60 minutes
        XCTAssertEqual(try! subtitleConverter.convert(to: .mpl2), "[72610][72660]Text.")
        XCTAssertEqual(try! subtitleConverter.convert(to: .microDVD), "{7261}{7266}Text.")
        XCTAssertEqual(try! subtitleConverter.convert(to: .subRip), "1\n02:01:01,000 --> 02:01:06,000\nText.\n")
        XCTAssertEqual(try! subtitleConverter.convert(to: .tmplayer), "02:01:01:Text.")

        // Negative offset.
        subtitleConverter.offset = -1000 // -1 second
        XCTAssertEqual(try! subtitleConverter.convert(to: .mpl2), "[36600][36650]Text.")
        XCTAssertEqual(try! subtitleConverter.convert(to: .microDVD), "{3660}{3665}Text.")
        XCTAssertEqual(try! subtitleConverter.convert(to: .subRip), "1\n01:01:00,000 --> 01:01:05,000\nText.\n")
        XCTAssertEqual(try! subtitleConverter.convert(to: .tmplayer), "01:01:00:Text.")

        subtitleConverter.offset = -1300 // -1.3 second
        XCTAssertEqual(try! subtitleConverter.convert(to: .mpl2), "[36597][36647]Text.")
        XCTAssertEqual(try! subtitleConverter.convert(to: .microDVD), "{3660}{3665}Text.")
        XCTAssertEqual(try! subtitleConverter.convert(to: .subRip), "1\n01:00:59,700 --> 01:01:04,700\nText.\n")
        XCTAssertEqual(try! subtitleConverter.convert(to: .tmplayer), "01:00:59:Text.")

        subtitleConverter.offset = -60_000 // -60 seconds
        XCTAssertEqual(try! subtitleConverter.convert(to: .mpl2), "[36010][36060]Text.")
        XCTAssertEqual(try! subtitleConverter.convert(to: .microDVD), "{3601}{3606}Text.")
        XCTAssertEqual(try! subtitleConverter.convert(to: .subRip), "1\n01:00:01,000 --> 01:00:06,000\nText.\n")
        XCTAssertEqual(try! subtitleConverter.convert(to: .tmplayer), "01:00:01:Text.")

        subtitleConverter.offset = -70_000 // -70 seconds
        XCTAssertEqual(try! subtitleConverter.convert(to: .mpl2), "[35910][35960]Text.")
        XCTAssertEqual(try! subtitleConverter.convert(to: .microDVD), "{3591}{3596}Text.")
        XCTAssertEqual(try! subtitleConverter.convert(to: .subRip), "1\n00:59:51,000 --> 00:59:56,000\nText.\n")
        XCTAssertEqual(try! subtitleConverter.convert(to: .tmplayer), "00:59:51:Text.")

        subtitleConverter.offset = -3_600_000 // -60 minutes
        XCTAssertEqual(try! subtitleConverter.convert(to: .mpl2), "[610][660]Text.")
        XCTAssertEqual(try! subtitleConverter.convert(to: .microDVD), "{61}{66}Text.")
        XCTAssertEqual(try! subtitleConverter.convert(to: .subRip), "1\n00:01:01,000 --> 00:01:06,000\nText.\n")
        XCTAssertEqual(try! subtitleConverter.convert(to: .tmplayer), "00:01:01:Text.")

        subtitleConverter.offset = -7_200_000 // -2 hours
        XCTAssertEqual(try! subtitleConverter.convert(to: .mpl2), "[0][0]Text.")
        XCTAssertEqual(try! subtitleConverter.convert(to: .microDVD), "{0}{0}Text.")
        XCTAssertEqual(try! subtitleConverter.convert(to: .subRip), "1\n00:00:00,000 --> 00:00:00,000\nText.\n")
        XCTAssertEqual(try! subtitleConverter.convert(to: .tmplayer), "00:00:00:Text.")
    }

    func testFrameRateError() {
        // Time based format without specified frame rate.
        do {
            let timeBasedSubtitleConverter = try SubtitleConverter(subtitles: "[3600][7200]Text.")
            let _ = try timeBasedSubtitleConverter.convert(to: .microDVD)
        } catch let error as SubtitleConvertionError {
            XCTAssertEqual(error, .frameRateNotSpecified)
        } catch {
            XCTFail("SubtitleConvertionError has not been thrown.")
        }

        // Frame based format without specified frame rate.
        do {
            let frameBasedSubtitleConverter = try SubtitleConverter(subtitles: "{1}{2}Text.")
            let _ = try frameBasedSubtitleConverter.convert(to: .subRip)
        } catch let error as SubtitleConvertionError {
            XCTAssertEqual(error, .frameRateNotSpecified)
        } catch {
            XCTFail("SubtitleConvertionError has not been thrown.")
        }
    }

    func testFrameRate() {
        // Time Based format to Frame Based format.
        var timeBasedSubtitleConverter = try! SubtitleConverter(subtitles: "[3600][7200]Text.")

        timeBasedSubtitleConverter.frameRate = 2.0
        XCTAssertEqual(try! timeBasedSubtitleConverter.convert(to: .mpl2), "[3600][7200]Text.")
        XCTAssertEqual(try! timeBasedSubtitleConverter.convert(to: .microDVD), "{720}{1440}Text.")

        timeBasedSubtitleConverter.frameRate = 10.0
        XCTAssertEqual(try! timeBasedSubtitleConverter.convert(to: .mpl2), "[3600][7200]Text.")
        XCTAssertEqual(try! timeBasedSubtitleConverter.convert(to: .microDVD), "{3600}{7200}Text.")

        // Frame Based format to Time Based format.
        var frameBasedSubtitleConverter = try! SubtitleConverter(subtitles: "{100}{200}Text.")

        frameBasedSubtitleConverter.frameRate = 2.0
        XCTAssertEqual(try! frameBasedSubtitleConverter.convert(to: .microDVD), "{100}{200}Text.")
        XCTAssertEqual(try! frameBasedSubtitleConverter.convert(to: .mpl2), "[500][1000]Text.")
        XCTAssertEqual(try! frameBasedSubtitleConverter.convert(to: .subRip), "1\n00:00:50,000 --> 00:01:40,000\nText.\n")
        XCTAssertEqual(try! frameBasedSubtitleConverter.convert(to: .tmplayer), "00:00:50:Text.")

        frameBasedSubtitleConverter.frameRate = 10.0
        XCTAssertEqual(try! frameBasedSubtitleConverter.convert(to: .microDVD), "{100}{200}Text.")
        XCTAssertEqual(try! frameBasedSubtitleConverter.convert(to: .mpl2), "[100][200]Text.")
        XCTAssertEqual(try! frameBasedSubtitleConverter.convert(to: .subRip), "1\n00:00:10,000 --> 00:00:20,000\nText.\n")
        XCTAssertEqual(try! frameBasedSubtitleConverter.convert(to: .tmplayer), "00:00:10:Text.")
    }

    func testFrameRateRatio() {
        var subtitleConverter = try! SubtitleConverter(subtitles: "[300][600]Text.")
        subtitleConverter.frameRate = 5.0

        subtitleConverter.frameRateRatio = 5.0 // For example: Change Frame Rate from 2.0 to 10.0.
        XCTAssertEqual(try! subtitleConverter.convert(to: .mpl2), "[1500][3000]Text.")
        XCTAssertEqual(try! subtitleConverter.convert(to: .microDVD), "{750}{1500}Text.")
        XCTAssertEqual(try! subtitleConverter.convert(to: .subRip), "1\n00:02:30,000 --> 00:05:00,000\nText.\n")
        XCTAssertEqual(try! subtitleConverter.convert(to: .tmplayer), "00:02:30:Text.")

        subtitleConverter.frameRateRatio = 0.5 // For example: Change Frame Rate from 20.0 to 10.0.
        XCTAssertEqual(try! subtitleConverter.convert(to: .mpl2), "[150][300]Text.")
        XCTAssertEqual(try! subtitleConverter.convert(to: .microDVD), "{75}{150}Text.")
        XCTAssertEqual(try! subtitleConverter.convert(to: .subRip), "1\n00:00:15,000 --> 00:00:30,000\nText.\n")
        XCTAssertEqual(try! subtitleConverter.convert(to: .tmplayer), "00:00:15:Text.")
    }

    func testMergeAdjacentWhitespaces() {
        var subtitleConverter = try! SubtitleConverter(subtitles: "01:12:33:Text  with   ugly spaces.")
        subtitleConverter.mergeAdjacentWhitespaces = true

        let convertedSubtitles = try! subtitleConverter.convert(to: .tmplayer)

        XCTAssertEqual(convertedSubtitles, "01:12:33:Text with ugly spaces.")
    }

    func testCorrectPunctuation() {
        var subtitleConverter = try! SubtitleConverter(subtitles: "01:12:33:Ugly ?! , punctuation .")
        subtitleConverter.correctPunctuation = true

        let convertedSubtitles = try! subtitleConverter.convert(to: .tmplayer)

        XCTAssertEqual(convertedSubtitles, "01:12:33:Ugly?!, punctuation.")
    }

}
