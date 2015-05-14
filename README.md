Cross Platform Tetris
=====================

This is a toy implementation of Tetris, with all
the game logic in pure ruby, that runs both locally
on the desktop, using Ruby's [Shoes](http://shoesrb.com/) project,
and in the browser, using [Opal.rb](http://opalrb.org/) and [React.js](https://facebook.github.io/react/)
(via the [React.rb](https://github.com/zetachang/react.rb/) wrapper)

(There is a current bug/feature/shortcut I'm aware of that completing rows not at the bottom currently
clears all rows below it as well...  just think of it as a cheat code for now!)

### With Shoes
![Tetris Shoes](https://github.com/bglusman/tetris/blob/master/Tetris%20Shoes%20Screenshot.png)

### With React
![Tetris React](https://github.com/bglusman/tetris/blob/master/Tetris%20Browser%20React%20Screenshot.png)
