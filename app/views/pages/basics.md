Basics
======

Much of this is taken from the
[robowiki](http://robowiki.net/), which has much more information. This page
mainly exists as an easy reference point and a backup in the event that we have
poor internet connectivity.

Battlefield and coordinate system
---------------------------------

![Alt coordinates](/images/fig2.gif)

The above image shows the coordinate system used for robocode. Notice that north
is 0 degrees and south is 180 degrees.

Important game physics
----------------------
**max velocity:** the maximum velocity your robot can move at is 8 pixels per
turn forwards or backwards

**max robot rotation:** the maximum you can turn is (10 - 0.75 * velocity)
degrees per turn. The faster you are moving, the slower you turn.

**max gun rotation:** 20 degrees per turn + current robot rotation rate

**max radar rotation:** 45 degrees per turn + current gun rotation rate

Bullets
-------

In robocode, you can shoot a bullet with a power from 0.1 to 3.0. Bullets with
more power travel slower but do more damage. Likewise, bullets with less power
travel faster but do less damage. Bullet damage is computed with the following
formula:

**bullet damage** = 4 * power

if power > 1, add an additional 2 * (power - 1)

> If you hit an enemy with a bullet you *gain* power equal to 3 * bullet power.
> This means that you can actually end up with more power than you started with,
> if you are accurate enough.


