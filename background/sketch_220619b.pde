PImage crab;
PImage stones;
PImage stones1;
PImage seaweed1;
PImage seaweed2;
PImage seaweed3;
PImage sea_snail;
PImage reef;
PImage malmizal;

void setup() {
  size(1200, 800);
  crab = loadImage("crab.png");
  stones = loadImage("stones.png");
  stones1 = loadImage("stone1.png");
  seaweed1 = loadImage("seaweed1.png");
  seaweed2 = loadImage("seaweed2.png");
  seaweed3 = loadImage("seaweed3.png");
  sea_snail = loadImage("sea-snail.png");
  reef = loadImage("reef.png");
  malmizal = loadImage("malmizal.png");
}

void draw() {
  background(184, 223, 248);
  noStroke();
  fill(240, 192, 128);
  rect(0, 785, 1200, 15);
  image(stones, 0, 700, 120, 120);
  image(stones1, 1100, 710, 100, 100);
  image(seaweed1, 100, 620, 150, 200);
  image(sea_snail, 110, 770, 30, 30);
  image(seaweed3, 180, 650, 150, 150);
  image(seaweed2, 280, 610, 150, 200);
  image(seaweed3, 400, 650, 150, 150);
  image(sea_snail, 400, 750, 50, 50);
  image(seaweed1, 470, 620, 150, 200);
  image(stones1, 700, 710, 100, 100);
  image(seaweed2, 800, 710, 150, 100);
  image(seaweed2, 900, 660, 150, 150);
  image(seaweed1, 1000, 620, 150, 200);
  image(reef, 620, 720, 80, 80);
  image(crab, 1050, 750, 50, 50);
  image(malmizal, 580, 750, 50, 50);
}
