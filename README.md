# Learning in the Cloud

Quiz yourself with questions formulated by IBM Watson's Natural Language Understanding API with source material drawn directly from your lecture notes.

## Inspiration

It's hard for us to forget all of the painfully long nights spent reviewing class material right before exams. We always wish that we started studying earlier, but with other classes and commitments to worry about, it's hard to set aside time to prepare practice material for ourselves.

That's why we made Learning in the Cloud: to help students like us. Learning in the Cloud helps take some of the burden of preparing practice quizzes and reviewing notes off of students by intelligently creating questions from lecture notes.

## What it does

Our mobile app takes student lecture notes as a list format and generates fill-in-the-blank style questions by redacting contextually important words from each bullet point. Features include Google account sign-in and persistent lecture note records associated with each user's account.

## How we built it

We used IBM Watson to identify keywords from user-generated phrases (lecture notes) to determine which words would create challenging practice questions when removed from sentences. We decided to select the keywords, which were oftentimes two or three words or entire phrases, that contained the fewest number of words rather than prioritizing "relevancy" -- a metric determined by Watson -- as we found that virtually any word identified as a keyword was clearly an acceptable choice for generating a question.

##### Built with

`dart` `flutter` `firebase` `IBM Watson Natural Language Understanding`

##### Made with love by [Long-Quan](https://github.com/lqbach), [Luke](https://github.com/MutatedGamer), [Salman](https://github.com/Salman78), and [Samantha](https://github.com/m-99)

