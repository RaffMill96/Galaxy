import ddf.minim.*;
AudioPlayer track1;
AudioSample pauseFx;
AudioSample hitFx;
Minim minim;

boolean pause = false;
boolean gameOver = false;
boolean gameStarted = false;

public int posX;
public int posY;
int y;
int currentScore;
int prevScore;
int pausedScore;
int numAsteroids = 20;

PFont pauseTxt;
PFont scoreTxt;

PImage background1;
PImage background2;
PImage background3;
PImage player;

Asteroids[] Asteroid = new Asteroids[numAsteroids];

void setup()
{
  PImage titlebaricon = loadImage("icon.png");
  surface.setIcon(titlebaricon);
  surface.setTitle("naaauuwelin"); 
  frameRate(60);
  size(320, 570);
  noSmooth();

  posX = width/2 - 20;
  posY = height - 50;

  background1 = loadImage("Background1.png");
  background2 = loadImage("Background2.png");
  background3 = loadImage("Background3.png");
  player = loadImage("sprite1.png");

  minim = new Minim(this);
  track1 = minim.loadFile("Lazerhawk - Shoulder Of Orion.wav");
  //track1 = minim.loadFile("codeday-song.mp3");
  pauseFx = minim.loadSample("pause.mp3");
  hitFx = minim.loadSample("hit.wav");

  pauseTxt = loadFont("ArcadeClassic.vlw");
  scoreTxt = loadFont("ArcadeClassic.vlw");

  for (int i = 0; i < numAsteroids; i++)
  {
    Asteroid[i] = new Asteroids();
  }
}

void draw()
{ 
  if (!gameStarted)
  {
    background(0); //Sets background to black when game over
    textFont(pauseTxt, 30);
    fill(255);
    text("PRESS [T] TO START", width/2 - 135, height/2);
    if (keyPressed && key == 't')
    {
      pauseFx.trigger();
      gameStarted = true;
      pausedScore = (millis()/100) - currentScore;
      pausedScore = millis()/100 - 20;
      gameOver = false;
    }
  }

  if (gameOver && gameStarted)
  {
    background(0); //Sets background to black when game over
    textFont(pauseTxt, 30);
    fill(255);
    text("G A M E  O V E R", width/2 - 130, height/2);
    text("SCORE: " + currentScore, width/2 - 70, height/2 + 40);
    textFont(pauseTxt, 20);
    text("Press [R]\n", width/2 - 45, height/2 + 65); 
    if (keyPressed && key == 'r')
    {
      pauseFx.trigger();
      for (int i = 0; i < numAsteroids; i++)
      {
        Asteroid[i].reset();
      }
      pausedScore = (millis()/100) - currentScore;
      pausedScore = millis()/100 -20;
      gameOver = false;
    }
  }
  if (pause && gameStarted)
  {
    pausedScore = (millis()/100) - currentScore;
    track1.pause();
    textFont(pauseTxt, 30);
    fill(255);
    text("P A U S E", width/2 - 70, height/2);
  }
  if (!pause && !gameOver && gameStarted)
  {
    currentScore = (millis() / 100) - pausedScore - 20;

    track1.play();
    scroll();
    player.resize(40, 40);
    image(player, posX, posY);
    score();
    move();
    checkBounds();

    for (int i = 0; i < numAsteroids; i++)
    {
      if (Asteroid[i].hit())
      {
        hitFx.trigger();
        gameOver = true;
      }
      Asteroid[i].display();
      Asteroid[i].move();
    }
  }
}//End of draw.

void move() 
{
  if (keyPressed && key == 'a') posX -= 6;
  if (keyPressed && key == 'd') posX += 6;
}

void keyPressed()
{ 
  if (!gameOver)
  {
    if (key == ' ')
    {
      pauseFx.trigger();
      pause = !pause;
    }
  }
}

void scroll()
{
  if (!pause) // MOVE BACKGROUND
  {
    // 640, 1140
    y += 15; 

    translate(0, y);
    image(background1, 0, 0);
    image(background2, 0, -570);
    image(background3, 0, -1140);
    image(background1, 0, -1710);

    if (y > 1710) 
    {
      y = 0;
    } 
    translate(0, -y);
  }
}

void checkBounds()
{
  if (posX >= width)
  {
    posX = 0;
  }
  if (posX < 0)
  {
    posX = width;
  }
}

void pause()
{
  track1.close();
}

void score()
{
  textFont(scoreTxt, 20);
  fill(255);
  text("SCORE: " + currentScore, 10, 20);
}



public class Asteroids
{
  float x,y;
  float xSpeed, ySpeed;
  PImage asteroid;
  Asteroids()
  {
    asteroid = loadImage("asteroid2.png");
    x = random(0, width - 30);
    y = random(-100, -50);
    ySpeed = random(3,5);
  }
  
  void reset()
  {
    x = random(-50, width + 50);
    y = random(-100, -50);
    ySpeed = random(3,5);
  }
  void display()
  {
    asteroid.resize(35,35);
    image(asteroid, x, y);
  }
  
  void move()
  {
    y += ySpeed;
    ySpeed += 0.001;
    
    if(y > height)
    {
      x = random(500);
      y = random(-200, -100);
    }
  }
  
  
  boolean hit()
  {
    float d = dist(x,y, posX, posY);
    if(d < 20)
     {
      //println("hit");
      return true;
    }
    else
    {
      return false;
    }
  }
  
  void gameOver()
  {
    textFont(pauseTxt, 30);
    fill(255);
    text("G A M E  O V E R", width/2 - 130, height/2);
    text("SCORE: " + currentScore, width/2 - 70, height/2 + 50);
  }
  
}
