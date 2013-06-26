Writing your first advanced bot
===============================

Moving components independently
-------------------------------

Having our robot, gun and radar tied together limits what we can do. We can't,
for instance, shoot at someone and be moving in a different direction. In order
to make it possible to turn the radar, gun and robot independently, we can add
the following lines at the start of our `run()` method.

```java
public void run() {
    setAdjustGunForRobotTurn(true);
    setAdjustRadarForGunTurn(true);
    setAdjustRadarForRobotTurn(true);
    ...
}
```

While this does allow us to make better use of our limited movements per turn,
it does require that we explicitly turn our gun and radar in addition to turning
our robot.

The run loop
------------

In very basic robots, most of the movement logic is handled by the "run" loop.
This is a sequence of actions that are repeated over and over again. The robot's
behavior is fixed by the steps in the loop.

```java
public void run() {
    ...
    while (true) {
        ...
        setTurnLeft(20);
        setAhead(100);
        setTurnRadarRight(360);
        waitFor(new TurnCompleteCondition(this));
    }
}
```

This robot will turn in a circle constantly, as it is always wanting to turn
left 20 degrees and move ahead 100 units. When we can `setTurnLeft`, `setAhead`,
etc., we are telling the robot that, at the end of your turn, I want you to
attempt to do these things. Take care when calling "set" methods!

```java
...
setAhead(100);
setAhead(50);
...
```

In the above code, it looks like we're telling the robot two different things.
We're first telling it to move ahead 100 units at the end of its turn. Then,
we're immediately telling it to move ahead 50 units at the end of its turn.
Which happens? Well, the LAST call to set for a given action (ahead, turnRight,
turnRadarRight, etc.) is what happens at the end of the turn. Therefore, when
this robot's turn is finished, it will attempt to move ahead 50 units, not 100.

In reality, the robot can only move a maximum of 8 units per turn, but it will
still eventually move the entire distance unless told otherwise. When using
"set" methods, we often specify a value greater than the maximum unless we
explicitly want to move less than the maximum allowed movement per turn.

Robots that rely on specifying their movement in the run loop are easy to target
since they move in predictable patterns. Even crazy, which randomly changes the
direction of its turn has moments of predictable movement. It is much better to
have a robot that reacts to its surroundings.

Reactionary programming
-----------------------

In real life, you react to changes in in your surroundings. When you're walking
down the sidewalk and you notice someone coming in the opposite direction, you
can adjust your movement to avoid running into them. This is an example of you
reacting to what you can see. Computer programs can react to the world around
them as well. We tend to think of code that reacts to inputs as being
reacitonary. Good robots will react to their surroundings as well.

In Robocode, a robot's eyes are its radar. Whenever the radar crosses another
robot, it triggers a `ScannedRobotEvent`, which triggers a call to your
`onScannedRobot` function.

```java
public void onScannedRobot(ScannedRobotEvent e) {
    // react to the scanned robot event
}
```

The simplest reaction we can have is to fire at the enemy robot:

```java
public void onScannedRobot(ScannedRobotEvent e) {
    double absoluteBearing = Utils.normalAbsoluteAngleDegrees(e.getBearing() + getHeading());
    double bulletPower = 1.5;
    double gunOffset = Utils.normalRelativeAngleDegrees(absoluteBearing - getGunHeading());
    shootWithAngleAndPower(gunOffset, bulletPower);
}
```

We can also change our movement based on the enemy robot. Here we try to get
away if the other robot is too close to us:

```java
public void onScannedRobot(ScannedRobotEvent e) {
    ...
    if (e.getDistance() < 200) {
        // turn perpendicular to the enemy robot
        // to do this, we figure out how much we'd have to turn to be
        // facing the enemy, then add 90 degrees to that angle
        double turnAngle = Utils.normalRelativeAngleDegrees(e.getBearing() + 90);
        setTurnRight(turnAngle);
        setAhead(100);
    }
    ...
}
```

In the above code, we are saying that, whenever the enemy robot is closer than
200 units to us, we want to move perpendicular to it. Importantly, every time we
scan this robot, if it is still too close to us, we will compute a new turn
angle. This will have the effect of "orbiting" the enemy (if you always move
perpendicular to a point, you are moving in a circle). However, always moving in
the same direction is predictable. How could you change your direction from time
to time? Maybe you could change your direction based on some other enemy
characteristic?

> What happens if we add fewer than 90 degrees when computing the turn angle?
> What happens when we add more than 90 degrees?

Radar movement
--------------

Since our radar is so vital to our ability to gather information, we need to be
sure to move our radar in a way that works best for the kind of bot that we're
working on. Since we can only move our radar a maximum of 40 degrees per turn,
it will take us 9 turns to turn our radar all the way around. Thus, if we are
simply spinning our radar around, it might take us up to 9 turns to scan the
other robot again.

Most radar movements are made up of two components: the "primary movement" and
the "backup movement." The backup movement lives in the `run()` loop, and
usually consists of spinning our radar if our radar has stopped turning:

```java
public void run() {
    while (true) {
        ...
        if (getRadarTurnRemaining() == 0) {
            setTurnRadarRight(Double.POSITIVE_INFINITY);
        }
        ...
    }
}
```

Basically, if our radar ever stops turning, tell set it to turn right "infinity"
degrees. Remember that any furture calls to `setTurnRadarRight` (or left) will
overwrite the previous value, so we don't have to worry about having to wait for
the radar to finish turning before we can move it in a different way.

### Mele radar ###


When facing many enemies, a spinning radar is sufficient. In this case, our
radar movement is just the backup component (spin your radar around infinitely).
There are more complex melee radars that involve moving to the last scanned enemy
first, but that's more advanced than you need to worry about right now.

### "Locking" radar ###


In 1v1 battles (and sometimes even in melee) the more frequently we can scan the
enemy robot, the better (since we can react more frequently). One way to
achieve this is with a "locking" radar:

```java
public void onScannedRobot(ScannedRobotEvent e) {
    ...
    double radarTurn = Utils.normalRelativeAngleDegrees(absoluteBearing - getRadarHeading());
    double extraTurn = Math.min(HTFUtil.atan(36.0 / e.getDistance()), Rules.RADAR_TURN_RATE);
    if (radarTurn < 0) {
        radarTurn = radarTurn - extraTurn;
    } else {
        radarTurn = radarTurn + extraTurn;
    }
    setTurnRadarRIght(radarTurn);
    ...
}
```

The way a locking radar works is by moving our radar back and forth across the
enemy robot. We do this by moving our radar a little bit past the enemy in each
direction. Now, there's a little bit of fancy math going on that lets us compute
the extra turn we want to use. You don't have to understand it right now, but,
in short, we compute an angle that is less than or equal to the max radar turn
(40) degrees and use that to turn slightly further than it would take to turn
our radar to directly face the enemy.

Using a locking radar has its downsides in melee battles, since you are focused
on one robot, you may not see the one behind you. Some advanced robots adapt
their radar strategy based on how many enemy robots are present on the field.
