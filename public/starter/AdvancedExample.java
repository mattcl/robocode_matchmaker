package htf;

import robocode.AdvancedRobot;
import robocode.ScannedRobotEvent;
import robocode.TurnCompleteCondition;
import robocode.util.Utils;

public class AdvancedExample extends AdvancedRobot {
	
	boolean requestedShot;
	long fireTime;
	double requestedPower;
	double lastHeading;
	double lastTime;

	public void run() {
		// move everything independently
		setAdjustGunForRobotTurn(true);
		setAdjustRadarForGunTurn(true);
		setAdjustRadarForRobotTurn(true);
		
		lastHeading = 0;
		lastTime = 0;
		
		while (true) {
			shootGun();
			if (getRadarTurnRemaining() == 0) {
				// whenever the radar turn is 0, start it moving again
				setTurnRadarRight(Double.POSITIVE_INFINITY);
			}
			execute();
		}
	}

	/*
	 * Here we delegate radar, movement, and gun code to specific functions
	 */
	public void onScannedRobot(ScannedRobotEvent event) {
		doRadar(event);
		doMovement(event);
		doGun(event);
	}

	/*
	 * Handle special radar code like locking your radar on a specific enemy
	 */
	public void doRadar(ScannedRobotEvent event) {
		// nothing for now
	}

	/*
	 * Handle special movement code. Here we just move in a circle
	 */
	public void doMovement(ScannedRobotEvent event) {
		setTurnRight(100);
		setAhead(100);
	}

	/*
	 * Handle special gun code. Here we just shoot directly at the enemy
	 */
	public void doGun(ScannedRobotEvent event) {
		double absoluteBearing = Utils.normalAbsoluteAngleDegrees(event.getBearing() + getHeading());
		shootWithAngleAndPower(absoluteBearing - getGunHeading(), 1.4);
	}

	/* 
	 * You can ignore this function. Basically, it serves to compensate for the
	 * "firing pitfall" - the fact that during a "turn," bullets are fired before
	 * the gun is turned
	 */
	public void shootWithAngleAndPower(double angleToTurn, double power) {
		angleToTurn = Utils.normalRelativeAngleDegrees(angleToTurn);
		setTurnGunRight(angleToTurn);
		if (!requestedShot) {
			requestedShot = true;
			requestedPower = power;
			fireTime = getTime() + 1;
		}
	}

	/*
	 * Like shootWithAngleAndPower, you can ignore this function as well.
	 */
	protected void shootGun() {
		if (requestedShot && getTime() >= fireTime && getGunTurnRemaining() == 0) {
			setFire(requestedPower);
			requestedShot = false;
		}
	}
}
