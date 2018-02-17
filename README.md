# Lab 2 - *PictaStream*

**PictaStream** is a photo browsing app app using the [The Tumblr API](https://www.tumblr.com/docs/en/api/v2#posts).

Time spent: **5** hours spent in total

## User Stories

The following **required** user stories are complete:

- [x] User can tab an image to view a larger image in a detail view (5pts)

The following **stretch** user stories are implemented:

- [ ] Add Avatar and Publish Dates (+2pt)
- [ ] Zoomable Photo View (+2pt)
- [ ] Infinite Scrolling (+2pt)

The following **additional** user stories are implemented:

- [ ] List anything else that you can get done to improve the app functionality! (+1-3pts)

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1.  I would like to add multiple streams and a search bar
2.  Is there a way to save an image to the phone?

## Video Walkthrough

Here's a walkthrough of implemented user stories:

![PictaStream Video Walkthrough](https://github.com/sks3/pictastream/blob/master/pictastream2.gif)

-GIF created with [LiceCap](http://www.cockos.com/licecap/).
-Placeholder icon by [jxnblk](http://jxnblk.github.io/) from [www.iconfinder.com](www.iconfinder.com).

## Notes

Describe any challenges encountered while building the app.

---------------------------------------------------------------------------------------------------------------

# Lab 1 - *PictaStream*

PictaStream is a photo browsing app using the [The Tumblr API](https://www.tumblr.com/docs/en/api/v2#posts).

Time spent: **4** hours spent in total

## User Stories

The following **required** user stories are complete:

- [x] User can scroll through a feed of images returned from the Tumblr API (5pts)

The following **stretch** user stories are implemented:

- [x] User sees an alert when there's a networking error (+1pt)
- [x] While poster is being fetched, user see's a placeholder image (+1pt)
- [x] User sees image transition for images coming from network, not when it is loaded from cache (+1pt)
- [x] Customize the selection effect of the cell (+1pt)

The following **additional** user stories are implemented:

- [x] Added loading state HUD while waiting for the images to load
- [x] User can "Pull to refresh" the image list
 
Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. I would like to implement the ability to view different image streams
2. How can allow for a streamed image to be downloaded to the device

## Video Walkthrough

Here's a walkthrough of implemented user stories:

![PictaStream Video Walkthrough](https://github.com/sks3/pictastream/blob/master/pictastream1.gif)

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

I modeled this app very closely to the CinemaBoss project, and plan to work on them in tandem.  When I first created this I named an IBOutlet "imageView", which caused undesired results.  Appropriately named outlets are a must!

## License

    Copyright 2018 Somi Singh

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
