# [elm-animate-list-items](https://kfrn.github.io/elm-animate-list-items)

This demo uses the [`elm-style-animation`](http://package.elm-lang.org/packages/mdgriffith/elm-style-animation/latest) library to produce a style animation with a secondary effect.

When you click to delete an item, it fades out before it is removed. Therefore, two messages are actually involved: `FadeOut` for the style change, to which is attached `RemoveItem`, which will delete the item from the model (and therefore DOM).

`elm-style-animation` has several very useful examples, including [this one](https://github.com/mdgriffith/elm-style-animation/blob/master/examples/SimpleSendMsg.elm) showing how to send messages.

However, most of the examples have very simple models, e.g.:
```elm
{ style : Animation.Messenger.State Msg }
```
The exception is [this example](https://github.com/mdgriffith/elm-style-animation/blob/master/examples/Showcase.elm) ([live version](https://mdgriffith.github.io/elm-style-animation/3.0.0/Showcase.html)), which involves a list of items.

This demo combines both these factors: the ability to perform an animation on any item in a list, and subsequently execute another action regarding that item.

### [Try it out!](https://kfrn.github.io/elm-animate-list-items)

### Setup Info

Dependencies:
* [Elm](https://guide.elm-lang.org/install.html)
* [Node](https://nodejs.org/en/download/)

To run locally:
```
git clone git@github.com:kfrn/elm-animate-list-items.git
cd elm-animate-list-items/
elm-package install
npm install -g create-elm-app
elm-app start
```

<!-- To deploy to github pages:
```
elm-app build
gh-pages -d build
```
-->
