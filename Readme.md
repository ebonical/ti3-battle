How it works
============

Create a game
-------------

Select **New Game** and add everybody's names who are playing. Just leave the 
empty slots blank. You can predetermine all the colours and races if you want 
or leave them on random.

This will create a code that you can give to your friends if they want to also 
manage their battles and all that jazz. 

Choosing **Join Game** and entering the game code will allow others to join.
Or link directly to the game with this URL format 
`http://ti3.ebonical.com/g/game-code`

Battle Board
------------

The steps are mostly obvious once inside the Battle Board. Increase unit numbers, 
modify any battle values if they haven't been applied yet and hit 'Roll Dice'. 
You can ignore the automatically generated values if you want and manually roll 
dice but you still have to press the button.

Battle Values are in the little target symbol and the number of dice to be rolled 
for a particular unit are represented as pips above the target. You should see 
that the War Sun has 3 pips. Pips will only be visible for values greater than 1.

### Resolving ###

If any hits have been scored you can now apply the damage to each unit. It 
isn't strict about how much damage you apply (although you can't add more than 
the number of units) so if you decided to roll your own dice, or something is 
incorrect, you can add more or less than is indicated.

Tap **Resolve Round** and a summary will appear for the end of the round. 
It will tell you how many units were lost and what all the dice rolls were.

If there are any units left then you can **Continue...**

If the Attacker wins and it's a Space Battle then a button to immediately start 
Invasion Combat will be shown for you convenience.

*Sustained Damage*: Damage applied to units like the War Sun or Dreadnought 
that can sustain damage will be carried over into the next round.


Pre-Combat Rounds
-----------------

The Battle Board should automatically switch in to a Pre-Combat Round when 
Destroyers and Fighters are present on opposite sides during Space Combat and 
when War Suns, Dreadnoughts or PDS are present during Invasion Combat.

This test only happens during Round 1 in the setup phase and if you click 
'Skip to Round 1' it will skip pre-combat for this battle.

The app doesn't handle any other types of pre-combat actions so you will have to 
manage these manually for now.


Technology Tree
===============

Mark off which technologies you have researched and where applicable 
(and currently possible) these will be applied to units in battle.

Tap a single technology and it will isolate the path to that technology. 
Tap the same one again to reveal all paths again.


Finally...
==========

Get the source code here if you want to fiddle or deploy your own version
<https://github.com/ebonical/ti3-battle> - it will deploy to Heroku just fine.

[![Creative Commons Licence](http://i.creativecommons.org/l/by-nc-sa/3.0/80x15.png)][license]  
This work is licensed under a 
[Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License][license].

All rights of the game *Twilight Imperium* and related content belong to 
Fantasy Flight Publishing. [Get the game][ff], it's good.

**Things still to do...**

* Toggle optional combat modifiers from racial abilities and game mechanics -
  like High Alert battle bonus and Letnev combat bonuses
* Leaders in combat
* Responsive styling to better fit web view in mobile browsers
* Switch to manage another player during game
* Apply pre-existing sustained damage to units like War Sun and Dreadnought
* Abilities that allow dice re-rolls for misses
* Write some tests!
* Show what technologies and abilities have been applied in a battle
* and lots of other things...


[ff]: http://www.fantasyflightgames.com/edge_minisite.asp?eidm=21&enmi=Twilight%20Imperium%203rd%20Edition
[license]: http://creativecommons.org/licenses/by-nc-sa/3.0/deed.en_GB
