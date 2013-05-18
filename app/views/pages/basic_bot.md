BasicBot
===========

The example bot is a basic Robot. It extends the base Robot class provided by
robocode. If you're unfamiliar with programming, the BasicBot is a good place
to start, since it doesn't rely on too many complicated programming concepts.

```java
package htf;

/*
 * imports in Java bring in external libraries that we might need.
 */
import java.awt.Color;

import robocode.HitByBulletEvent;
import robocode.HitWallEvent;
import robocode.Robot;
import robocode.ScannedRobotEvent;
import robocode.util.Utils;

public class BasicBot extends Robot {

	public void run() {
		setColors();
		// This is the main loop. everything in the loop will be run over and
		// over again. Here, we are just moving in a "square"
		while (true) {
			turnLeft(90);
			ahead(100);
		}
	}

	public void setColors() {
		/* available colors:
		 * black, blue, cyan, darkGrey, gray, green, lightGray,
		 * magenta, orange, pink, red, white, yellow
		 */
		this.setColors(
				Color.red, // body color
				Color.cyan, // gun color
				Color.blue, // radar color
				Color.green, // bullet color
				Color.white // scan arc color
				);
	}

	/*
	 * This function is called whenever our radar scans another robot.
     * since the radar is fixed in place for BasicBot, it happens whenever
     * another robot is directly ahead of us.
	 */
	public void onScannedRobot(ScannedRobotEvent e) {
		fire(1.5);
	}

	/*
	 * Whenever you are hit by a bullet, this function is called. Here, we're
	 * using it to turn 90 degrees and move ahead 200. This will hopefully
	 * move us out of the way of another shot.
	 */
	public void onHitByBullet(HitByBulletEvent e) {
		turnRight(90);
		ahead(200);
	}

	/*
	 * Whenever your robot runs into a wall, this event is triggered. Here, we
	 * use it to move backwards 150 and turn 90 degrees. This should hopefully
	 * prevent us from hitting a wall on our next set of moves.
	 */
	public void onHitWall(HitWallEvent e) {
		ahead(-150); // this moves the robot backwards 150
		// you could also call back(150);
		turnRight(90);
	}
}
```
