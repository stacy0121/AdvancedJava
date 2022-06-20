ArrayList<Food> foods = new ArrayList<Food>();
PImage photo;
int angle=60;
PVector posC; // 클릭 회피를 위한 좌표
boolean flag = false;   // 우클릭 상태
ArrayList<Fish> chefish = new ArrayList<Fish>();
ArrayList<Fish> fishes = new ArrayList<Fish>();

float a=365; //뜰채 원 x좌표
float b=250; //뜰채 원 y좌표
PVector posCF;

//PImage crab;
//PImage stones;
//PImage stones1;
//PImage seaweed1;
//PImage seaweed2;
//PImage seaweed3;
//PImage sea_snail;
//PImage reef;
//PImage malmizal;

Fish newborn;

void setup() {
  size(800, 800);
  frameRate(10);
  for (int i=0; i<20; i++) fishes.add(new Fish());   // 배열 속 객체 생성
  photo = loadImage("che.png");
}

void draw() {
  background(184, 223, 248);
  noStroke();
  fill(240, 192, 128);
  rect(0, 785, 1200, 15);
  //image(stones, 0, 700, 120, 120);
  //image(stones1, 1100, 710, 100, 100);
  //image(seaweed1, 100, 620, 150, 200);
  //image(sea_snail, 110, 770, 30, 30);
  //image(seaweed3, 180, 650, 150, 150);
  //image(seaweed2, 280, 610, 150, 200);
  //image(seaweed3, 400, 650, 150, 150);
  //image(sea_snail, 400, 750, 50, 50);
  //image(seaweed1, 470, 620, 150, 200);
  //image(stones1, 700, 710, 100, 100);
  //image(seaweed2, 800, 710, 150, 100);
  //image(seaweed2, 900, 660, 150, 150);
  //image(seaweed1, 1000, 620, 150, 200);
  //image(reef, 620, 720, 80, 80);
  //image(crab, 1050, 750, 50, 50);
  //image(malmizal, 580, 750, 50, 50);
  
  pushMatrix();
  rotate(radians(angle));
  if (keyPressed) {
    if (key=='r'||key == 'R') {
      angle--;
      ellipse(a, b, 150, 100);
      image(photo, 0, 0);
      posCF = new PVector(a, b);
      posCF.rotate(radians(angle));
    }
  }
  popMatrix();

  for (int i = fishes.size()-1; i>=0; --i) fishes.get(i).draw();   // 물고기 그리기

  if (foods.size()>=0) {
    for (int i=0; i<foods.size(); i++)  foods.get(i).draw();   // 먹이 생성
  }
}

void keyReleased() {
  angle=60;
}

// 마우스 클릭 이벤트
void mousePressed() {
  if (mouseButton == LEFT) {  // 좌클릭 먹이 생성
    foods.add(new Food());    // 객체 생성 및 배열에 넣기
  } else if (mouseButton == RIGHT) {   // 우클릭 클릭 좌표 저장
    posC = new PVector(mouseX, mouseY);
    noFill();
    circle(mouseX, mouseY, 20);   // 파티클
  }
}

// 물고기 클래스****************************
class Fish {
  PVector pos;   // 물고기 위치
  boolean direction = true;   // 방향 지시 (기본 오른쪽)

  float distR;
  float distCF;   // 클릭 좌표

  int size = 1;
  int sizeTW = 10;
  int sizeTH = 5;
  int sizeW = 15;
  int sizeH = 10;

  Fish() {
    pos = new PVector(random(0, width), random(0, height-15));   // 랜덤 스폰
  }

  void draw() {
    // <먹이 추적>
    // 방향 파악, 위치 관계
    int minDistFood = 0;
    float minDist=Float.MAX_VALUE;
    float distC;

    // 평상시 움직임
    PVector vel=null;
    // vel.x > 0
    if (direction==true) {   // 오른쪽으로 이동하는 물고기 그림
      vel = new PVector(random(0, 12), random(-1, 1));
      pos.add(vel);
    } else {   // 왼쪽으로 이동
      vel = new PVector(-random(0, 12), -random(-1, 1));
      pos.add(vel);
    }
    
    // 타겟 선정
    // 가까운 애들 추적
    if (foods.size()>=0) {
      for (int i=0; i<foods.size(); i++) {
        float dist = PVector.dist(pos, foods.get(i).posF);
        if (dist<minDist) {
          minDist = dist;
          minDistFood = i;   // 가장 가까운 먹이
        }
      }
    }
    
    // 가장 가까운 먹이와의 거리가 100 미만이면
    if (minDist<100) {
      Food target = foods.get(minDistFood);   // 그 먹이를 타겟으로 설정
      // 속도 크기, 방향 계산
      vel = PVector.sub(target.posF, pos);
      // 속도 지정
      vel.normalize();
      vel.mult(5);       // 크기 5만큼 먹이 쪽으로
      pos.add(vel);   // 속도 기반 위치(pos) 업데이트
    }
    
    // 먹이를 먹으면 (거리가 가까워지면)
    if (minDist<10 && size < 3) {
      // 먹이를 없애고 크기 키우기
      foods.remove(minDistFood);
      // size 변수, sizeTW = 10, sizeTH = 5, sizeW= 15; int sizeH = 10
      size++;
      sizeTW +=10;
      sizeTH +=5;
      sizeW +=15;
      sizeH +=10;
    }

    // <우클릭을 하거나 r키를 누르면 회피>
    if (mousePressed && mouseButton==RIGHT) {
      distC = PVector.dist(pos, posC);   // 클릭 좌표와의 거리 계산
      if (distC<100) {   // 거리가 100 이하면
        // 속도 크기, 방향 계산
        vel= PVector.sub(posC, pos);
        // 속도 지정
        vel.normalize();   // 크기 1
        vel.mult(-5);      // 반대쪽으로
        pos.add(vel);      // 속도 기반 위치 업데이트
      }
    } else if ((keyPressed && key=='r' &&  key=='R')) {
      //채 회피
      PVector velCF = null;
      distCF = PVector.dist(pos, posC);   // 클릭 좌표와의 거리 계산
      if (distCF<100) {   // 거리가 100 이하면
        // 속도 크기, 방향 계산
        velCF = PVector.sub(pos, posCF);
        // 속도 지정
        velCF.normalize();   // 크기 1
        velCF.mult(-5);      // 반대쪽으로
        pos.add(velCF);      // 속도 기반 위치 업데이트
      }
    }

    // 채 회피
    // 가까운 물고기 추적
    if (fishes.size()>=0) {
      for (int k=0; k<fishes.size(); k++) {
        if (posCF != null) {
          distCF = PVector.dist(posCF, fishes.get(k).pos);   // 둘의 좌표계가 다름
          // 거리 100 미만인 물고기 배열에 넣기
          if (distCF<100) {
            chefish.add(fishes.get(k));
            fishes.get(k).pos = posCF;
            if ( pos.y < 0  && chefish.contains(this) == true) {
              chefish.remove(this);
              fishes.remove(this);
            }
          }
        }
      }
    }

    // 경계조건 (방향 전환)
    if (pos.x>width) direction = false;   // 오른쪽으로 끝까지 갔을 때
    // if(vel!=null) vel.x *= -1;
    if (pos.x<0) direction = true;
    if (pos.y>height) pos.y=0;
    if (pos.y<0) pos.y=height;
    
    // 그리기 
    // 마지막 조건에 따라 물고기 그리기
    pushMatrix();
    translate(pos.x, pos.y);   // 물고기 위치로 좌표계 이동
    
    stroke(0);
    if (size == 1) fill(255);
    else if (size ==2)  fill(255, 217, 236);
    else fill(255, 0, 0);
    
    //if (vel!=null) {             // nullPointerException 방지
      float theta = vel.heading();   // 먹이 방향 회전 각도
      rotate(theta);
      //if (posC != null) {
      //  //rotate(directionAngle);
      //}
    //}
    
    triangle(0, 0, 0-sizeTW, 0-sizeTH, 0-sizeTW, 0+sizeTH);   // 꼬리(좌표계 이동 상태)
    ellipse(0, 0, sizeW, sizeH);   // 몸통
    popMatrix();
  }
}

// 먹이 클래스****************************
class Food {
  PVector posF;

  Food() {
    posF = new PVector(mouseX, mouseY);
  }

  void draw() {
    fill(57, 29, 0);   // 갈색
    circle(posF.x, posF.y, 10);

    // 중력 작용
    posF.y+=3;

    if (posF.y>height) posF.y=height;   // 땅에 떨어짐
  }
}
