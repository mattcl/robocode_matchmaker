Angles in robocode
==================

Bearings
--------

![bearings](/images/abs_b_vs_b.png)

In robocode, the **bearing** is the amount you have to turn to be facing the
target. The absolute bearing is the amount you would have to turn **if you were
facing north**. How do you compute this value? Well, whenever your radar scans
and enemy robot, it triggers a call to onScannedRobot(), passing a
ScannedRobotEvent which has information about the scanned robot. You can extract
information from the ScannedRobotEvent to compute the bearing and absolute
bearing.

Below is an example of computing the bearing and absolute
bearing in the onScannedRobot function:

```java
public void onScannedRobot(ScannedRobotEvent e) {
    double bearing = e.getBearing();
    double absoluteBearing = Utils.normalAbsoluteAngleDegrees(bearing + getHeading());
}

```

> What is Utils.normalAbsoluteAngleDegrees(...)? Well, we want to limit the
> absolute bearing to be between 0 and 360 degrees. The utility function ensures
> that this is the case. Remember that 390 degees is the same as 30 degrees,
> since there are 360 degrees in a full circle. There is a
> Utils.normalRelativeAngleDegrees(...) that takes an angle and makes sure that
> it lies between -180 and 180 degrees.

The **bearing** is important in moving your robot relative to the scanned robot.
Say you wanted to turn your robot directly at the scanned enemy:

```java
public void onScannedRobot(ScannedRobotEvent e) {
    double bearing = e.getBearing();
    ...
    setTurnRight(bearing);
    // if you're not using an AdvancedRobot, you can just call
    // turnRight(bearing);
}

```

The **absolute bearing** is important in moving your gun (and radar). It
provides a constant reference point. Remember that your gun isn't always facing
the same direciion that your robot is facing! The following code shows you how to make sure your gun is facing the scanned enemy.

```java
public void onScannedRobot(ScannedRobotEvent e) {
    double bearing = e.getBearing();
    double absoluteBearing = Utils.normalAbsoluteAngleDegrees(bearing + getHeading());

    double gunTurn = Utils.normalRelativeAngleDegrees(absoluteBearing - getGunHeading());

    setTurnGunRight(gunTurn);
    // if you're not using an AdvancedRobot, you can just call
    // turnGunRight(gunTurn);
}

```

We compute the amount we need to turn our gun by subtracting our current gun
heading from the absolute angle. This way, we know exactly how much to turn our
gun.

Consistency
-----------

![bearings2](/images/abs_b_vs_b_2.png)

As the above image illustrates, there are times when the **bearing** is
negative. This is because the bearing will always be the shortest distance to
turn. Here we can see that the **absolute bearing will always be a positive**.

Here's another image to illustrate that point

![bearings2](/images/abs_b_vs_b_3.png)
