# MonthlySales
### A revenue overview for developers, based on Apple's Fiscal Calendar

![Screenshot 1](https://raw.githubusercontent.com/fouquet/MonthlySales/master/Screenshots/monthlySales-1.png)

![Screenshot 2]https://raw.githubusercontent.com/fouquet/MonthlySales/master/Screenshots/monthlySales-2.png)

If you have one or more paid apps on the Apple App Store(s), you know that Apple uses a different calendar for bookkeeping than the actual calendar months. So for example for Apple, the month of March 2017 isn't from March 1 to March 31, it's from March 5 until (including) April 1. 

Pretty much all sales analytics services, however, report sales on a calendar month basis–including AppFigures and iTunes Connect itself. To find out how much money you're *actually* making in a given month, you need to figure out [Apple's fiscal month](https://itunesconnect.apple.com/WebObjects/iTunesConnect.woa/wa/jumpTo?page=fiscalcalendar) and set the start end/end date in the sales analytics software to get your actually revenue. 

MonthlySales is an iOS app created to make that easier. It's designed to give you an immediate overview over how much money you've already earned in the current fiscal month, and how much you can likely expect.

**Note**: MonthlySales uses the AppFigures API and requires an AppFigures account. I think free accounts work, but don't quote me on that.

## Installation

The installation is very easy to do. Just clone this repo, open the project in Xcode, and select the file **ApiMethods.swift**. Now go to the [AppFigures API clients section](https://appfigures.com/developers/keys) and create a new client (you can call it whatever you like). Make sure to set all permissions to *read*. After clicking "Make me an app", write down the *client key*.

Now open Terminal.app in macOS, and enter:

	echo -n 'APPFIGURESUSER:APPFIGURESPASSWORD' | base64
	
where `APPFIGURESUSER` is your AppFigures user name, and `APPFIGURESPASSWORD` is your AppFigures password. As a result you'll receive a base64 encoded string. You'll need this in a moment.

In the file **ApiMethods.swift**, at the top of the class `ApiMethods`, there are three constants you need to change:

* `clientKey`: The "client key" from the AppFigures API panel
* `authorizationKey`: Created by you using the Terminal, remember?
* `userEmail`: The Email address of your AppFigures account

Now you can run the app on your favorite Simulator, device or whatever. It should display your sales based on the fiscal calendar.

## Things to know

MonthlySales will always display all revenue for all products tracked in AppFigures, including IAP. It will not individually show results depending on products, country or your mom. It's intentionally kept simple to just show revenue for a given fiscal calendar month, that's it.

* The amount under "**Revenue**" on the left is the total revenue in the selected fiscal month.
* In the center, under "**Days**", is the number of remaining days in the selected fiscal month.
* On the far right, under "**Est. Total**" is the estimated total revenue of the selected fiscal month. This is based on the average of all sales in this timeframe. It will be very wrong in the first few days, but will be getting progressively more accurate. If I were Apple I would spice it up with words like "Machine Learning" etc, but it's really just the average. Sorry.

Below this, there's a UITableView displaying all sales of the current fiscal month, sorted ascending by date.

If a date is yesterday and the revenue is 0, it is kept from the "days remaining", "total" and "estimated" counters. This is because this usually happens because Apple hasn't released the latest results yet. If you *actually* had  0 revenue yesterday, it won't count that. I'm sorry (both for this behaviour and the fact that you had no sales). This shouldn't be a problem for most people though.

The currency symbol ($, €, £ etc.) is loaded once at start and after that never refreshed automatically. If for some weird reason the currency setting of the AppFigures account changes, you can refresh this setting manually on the settings view.

## Requirements

MonthlySales is written in Swift 3.1 and testet with iOS 10 and designed for the iPhone. It *should* run in iOS 9 though. No idea. Who still uses iOS 9?

The project itself has no external dependencies, except for UIKit and Foundation (duh).

## Possible Questions

### Why use the AppFigures API? Doesn't iTunes Connect report the sales directly?

Yes, but there's no official API to use. This means web scraping and every time something changes on Apple's part, I need to adjust. No thanks.

Should Apple at some point decide to add an API, I'm happy to use that instead.

### Why Basic Authentication?

MonthlySales uses HTTP AuthBasic to authenticate with AppFigures. There's really no point in implementing OAuth if you only use it with your own account.

### Can you automatically sync the AppFigures data?

Unfortuntely, I can't. The API doesn't offer this functionality. If you're tired of manually triggering a data sync, you're forced to get an AppFigures Premium account :(

### The AppFigures sales dashboard shows a slightly different revenue amount for the given period

I've noticed this too. Sometimes the amount displayed in the AppFigures web frontend or the app is off by a few cents. The amount calculated by the app is correct, however, at least given the data coming from the AppFigures API. I can only assume that the web frontend does some funky rounding. It's in the ballpark though, so I don't think that's an issue.

### I need feature X to use this.

Feel free to fork the repo, add your feature and create a pull request. I'm always open to new features.

### Who designed this *horrible* icon? And that name sucks.

I did, and I know. Don't judge me.

### Are these your revenue numbers in the screenshot?

I wish.

### Do you have a tip jar or something? I want to pay you.

I don't, but I have [some apps](https://fouquet.me/apps) you can buy.

## Things to do

Here's a couple of things that still need to be done:

* UI Tests
* A couple of unit tests are missing
* Actual error alerts if something goes wrong

## Contact

Follow me on Twitter at @renefouquet or read my blog at [fouquet.me](https://fouquet.me)!

## License

**MIT License**

Copyright (c) 2017 René Fouquet

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.