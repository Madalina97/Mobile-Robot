/*
Adept MobileRobots Robotics Interface for Applications (ARIA)
Copyright (C) 2004-2005 ActivMedia Robotics LLC
Copyright (C) 2006-2010 MobileRobots Inc.
Copyright (C) 2011-2015 Adept Technology, Inc.
Copyright (C) 2016-2018 Omron Adept Technologies, Inc.

     This program is free software; you can redistribute it and/or modify
     it under the terms of the GNU General Public License as published by
     the Free Software Foundation; either version 2 of the License, or
     (at your option) any later version.

     This program is distributed in the hope that it will be useful,
     but WITHOUT ANY WARRANTY; without even the implied warranty of
     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
     GNU General Public License for more details.

     You should have received a copy of the GNU General Public License
     along with this program; if not, write to the Free Software
     Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

If you wish to redistribute ARIA under different terms, contact 
Adept MobileRobots for information about a commercial version of ARIA at 
robots@mobilerobots.com or 
Adept MobileRobots, 10 Columbia Drive, Amherst, NH 03031; +1-603-881-7960
*/
#include "Aria.h"
#include <iostream>
#include <fstream>
#include <string>
using namespace std;

/** @example gotoActionExample.cpp Uses ArActionGoto or ArActionGotoStraight 
   (modify code to switch) to drive the robot in a square
 
  This program will make the robot drive in a 2.5x2.5 meter square by
  setting each corner in turn as the goal for the action.
  It also uses speed limiting actions to avoid collisions. After some 
  time, it cancels the goal (and the robot stops due to a stopping action) 
  and exits.

  You can modify the code below to change the type of <tt>gotoPoseAction</tt>
  to either ArActionGotoStraight or ArActionGoto to compare these if you wish.
  (These are slightly different actions with similar interfaces; generally 
  ArActionGotoStraight is preferred, and has a few more options.)
*/

int main(int argc, char **argv)
{
  Aria::init();
  ArArgumentParser parser(&argc, argv);
  parser.loadDefaultArguments();
  ArRobot robot;
  ArAnalogGyro gyro(&robot);
  ArSonarDevice sonar;
  ArRobotConnector robotConnector(&parser, &robot);
  ArLaserConnector laserConnector(&parser, &robot, &robotConnector);


  // Connect to the robot, get some initial data from it such as type and name,
  // and then load parameter files for this robot.
  if(!robotConnector.connectRobot())
  {
    ArLog::log(ArLog::Terse, "gotoActionExample: Could not connect to the robot.");
    if(parser.checkHelpAndWarnUnparsed())
    {
        // -help not given
        Aria::logOptions();
        Aria::exit(1);
    }
  }

  if (!Aria::parseArgs() || !parser.checkHelpAndWarnUnparsed())
  {
    Aria::logOptions();
    Aria::exit(1);
  }

  ArLog::log(ArLog::Normal, "gotoActionExample: Connected to robot.");

  robot.addRangeDevice(&sonar);
  robot.runAsync(true);

  // Collision avoidance actions at higher priority
  ArActionLimiterForwards limiterAction("speed limiter near", 300, 600, 250);
  ArActionLimiterForwards limiterFarAction("speed limiter far", 300, 1100, 400);
  ArActionLimiterTableSensor tableLimiterAction;
  robot.addAction(&tableLimiterAction, 100);
  robot.addAction(&limiterAction, 95);
  robot.addAction(&limiterFarAction, 90);

  // Goto action at lower priority
  //ArActionGoto gotoPoseAction("goto");
  ArActionGotoStraight gotoPoseAction("gotostraight");
  robot.addAction(&gotoPoseAction, 50);
  
  // Stop action at lower priority, so the robot stops if it has no goal
  ArActionStop stopAction("stop");
  robot.addAction(&stopAction, 40);


  // turn on the motors, turn off amigobot sounds
  robot.enableMotors();
  robot.comInt(ArCommands::SOUNDTOG, 0);

  const int duration = 30000; //msec
  ArLog::log(ArLog::Normal, "Going to four goals in turn for %d seconds, then cancelling goal and exiting.", duration/1000);

  string linie;
  double v[6];
  int counter = 0;

  ArTime start;
  start.setToNow();
  
  FILE *rob;
  rob = fopen("/home/cristi/Documents/Licenta_Program/Poz_robot.txt","w+");
  while (Aria::getRunning()) 
  { 
     string Mytext;
     int stop = 1;
     ArUtil::sleep(500);
     while ( stop == 1 )
     {
   	robot.lock();
   	robot.setVel(0);
   	robot.unlock();
   	ArUtil::sleep(100);
   	ifstream Myfile("/home/cristi/Documents/Licenta_Program/Scaneaza.txt");
   	getline(Myfile, Mytext);
   	if (Mytext == "0")
   	{
   	   stop = 0;
   	   Myfile.close();
   	}
    }
   
    printf("Read \n");	
    ArUtil::sleep(500);
    counter = 0;
    ifstream fin("/home/cristi/Documents/Licenta_Program/traseu.txt");
    while(getline(fin, linie))
    {
    	v[counter] = stod(linie);
    	++counter;	
    	
    }
    fin.close();
    printf("Go \n");
    
    for (int i = 0; i < 6; ++i)
    {
    	cout << v[i] << "  ";
    }
   int i = 0;
   
   while(i < 6 )
   {
      printf("Angle \n");
      robot.lock();
      robot.setDeltaHeading(v[i]);
      robot.unlock();
      ArUtil::sleep(1000);
      printf("Move \n");
      robot.lock();
      robot.move(80);
      robot.unlock();
      ArUtil::sleep(500);
      ++i;
      fprintf( rob, "%4.4f \t %4.4f \t %4.4f \n", robot.getX(), robot.getY(), robot.getTh());
   }
   
   printf("Create file - Scaneaza\n");
   ofstream outfile;
   outfile.open("/home/cristi/Documents/Licenta_Program/Scaneaza.txt");
   outfile << "1";
   outfile.close();
 
   robot.unlock();
   ArUtil::sleep(500);
     
  }
     fclose(rob);
 
  // Robot disconnected or time elapsed, shut down
  Aria::exit(0);
  return 0;
}

