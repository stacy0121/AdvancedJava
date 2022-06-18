//Fish[] fishes = new Fish[20];   // 객체 배열 생성
ArrayList<Food> foods = new ArrayList<Food>();
PImage photo;
int angle=60;
PVector posC; // 클릭 회피를 위한 좌표
PVector posR;
boolean flag = false;   // 우클릭 상태
ArrayList<Fish> chefish = new ArrayList<Fish>();
ArrayList<Fish> fishes = new ArrayList<Fish>();


void setup() {
  size(800, 800);
  frameRate(10);
  for (int i=0; i<20; i++) fishes.add(new Fish());   // 배열 속 객체 생성
  photo = loadImage("che.png");
}

void draw() {
  background(255);

  for (Fish r : fishes) r.draw();   // 물고기 그리기

  if (foods.size()>=0) {
    for (int i=0; i<foods.size(); i++)  foods.get(i).draw();   // 먹이 생성
  }
  
  CheFish cheafish = new CheFish();
  cheafish.draw(); 
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

  Fish() {
    pos = new PVector(random(0, width), random(0, height));   // 랜덤 스폰
  }

  void draw() {
    // <먹이 추적>
    // 방향 파악, 위치 관계
    int minDistFood = 0;
    float minDist=Float.MAX_VALUE;
    float distC;


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
    PVector vel=null;

    // 가장 가까운 먹이와의 거리가 100 미만이면
    if (minDist<100) {
      Food target = foods.get(minDistFood);   // 그 먹이를 타겟으로 설정
      // 속도 크기, 방향 계산
      vel = PVector.sub(target.posF, pos);
      // 속도 지정
      vel.normalize();
      vel.mult(5);       // 크기 5만큼 먹이 쪽으로

      pos.add(vel);   // 속도 기반 위치(pos) 업데이트

      // 먹이를 먹으면 (거리가 가까워지면)
      if (minDist<10) {
        // 먹이를 없애고 크기 키우기*****************지원
        foods.remove(minDistFood);
      }
    }
    // 오른쪽으로 이동하는 물고기만 반대로 가게**************************
    // <클릭하고 있으면 회피>
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
    }

    // 경계조건 (방향 전환)
    if (pos.x>width) direction = false;   // 오른쪽으로 끝까지 갔을 때
    if (pos.x<0) direction = true;
    if (pos.y>height) pos.y=0;
    if (pos.y<0) pos.y=height;

    // 이동하던 방향에 반대로 가는 물고기 그리기
    pushMatrix();
    translate(pos.x, pos.y);   // 물고기 위치로 좌표계 이동
    if (vel!=null) {             // nullPointerException 방지
      float theta = vel.heading();   // 먹이 방향 회전 각도
      rotate(theta);
    }
    
    fill(255);
    if (direction==true) {   // 오른쪽으로 이동하는 물고기 그림
      pos.x += random(-5, 10);
      pos.y += random(-2, 2);
      triangle(0, 0, 0-10, 0-5, 0-10, 0+5);   // 꼬리(좌표계 이동 상태)
      ellipse(0, 0, 15, 10);   // 몸통
    } else {   // 왼쪽으로 이동
      pos.x -= random(-5, 10);
      pos.y -= random(-2, 2);
      triangle(0, 0, 0+10, 0+5, 0+10, 0-5);   // 꼬리
      ellipse(0, 0, 15, 10);   // 몸통
    }
    popMatrix();
  }
}

class CheFish {
  float a=365; //뜰채 원 x좌표
  float b=250; //뜰채 원 y좌표
  float distR;
  PVector pos;
  float dist;

  CheFish() {
    pos = new PVector(a, b);
  }

  void draw() {
    float minDist=Float.MAX_VALUE;
    int minDistFish = 0;
    pushMatrix();
    rotate(radians(angle));
    if (keyPressed) {
      if (key=='r'||key == 'R') {
        angle--;
        ellipse(a, b, 150, 100);
        image(photo, 0, 0);
      }
    }
    popMatrix();   // 어디 위치?
    //if (angle>=60) {
    // 가까운 물고기 추적
    if (fishes.size()>=0) {
      for (int k=0; k<fishes.size(); k++) {
        dist = PVector.dist(pos, fishes.get(k).pos);   // pos
        if (dist<100) {
          chefish.add(fishes.get(k));

          // 거리 100 미만인 물고기 배열에 넣기  (fishes.get(k))
        }
        //            if (dist<minDist) {
        //              minDist = dist;
        //              minDistChe = k;   // 가장 가까운 물고기
        //            }

        //popMatrix();   // 어디 위치?
      }
    }
    //회피
    //for문을 써서 배열에서 뺴기
    PVector vel = null;
    for (int i=0; i<chefish.size(); i++) {
      // 속도 크기, 방향 계산
      vel= PVector.sub(chefish.get(i).pos, pos);
      // 속도 지정
      vel.normalize();   // 크기 1
      vel.mult(-5);      // 반대쪽으로
      chefish.get(i).pos.add(vel);      // 속도 기반 위치 업데이트

      // 뜰채에 떠짐(제거)
      if (dist<5) {
        // for문 if랑 위치 바꿔줘보기
        chefish.remove(i);
      }
    }
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
