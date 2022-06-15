import java.util.Random;
PImage img,rkd,jkd,tkd;
float syougai_num = 9;
float[] syougai_x = new float[1000];
float[] syougai_y = new float[1000];
float[] syougai_dx = new float[1000];
float r = 10.0;
float x = 200; //x座標
float y = 20; //y座標
double vx, vy, vy0, ty, tx; //速度, 初速度, 時間
double e = 0.35; //反発係数
double g = 9.80665; //重力加速度
int mode = 0; //上昇と下降の切り替え
float ex, ey; //x:円のx座標,y:円のy座標
int distance;
String scene = "start";
int cc = 1;
int c = 0;
double[] gxl = {150, 300, 450};
float[] gyl = {600, 500, 700};
double[] grl = {40, 20, 30};
double[] gl = {10, 50, 30};
int[] desin_x = new int[60];
int[] desin_y = new int[60];
int[] desin_speed = new int[60];
int count = 0;
int score = 0;
String freebie;

void setup() {
    size(600, 800);
    frameRate(80);
    ex = 200;
    ey = 40;
    setup_syougai();
    photo_screen();
    for (int i = 0; i < 60; i++) {
        desin_x[i] = int(random(width));
        desin_y[i] = 850;
        desin_speed[i] = int(random(2,6));
    }
}

void draw() {
    if (scene == "start") {
        background(24,235,249);
        image(tkd,100,100,400,250);
        image(jkd,500,700,80,50);
        game_start_screen();
    }
    else if (scene == "game") {
        make_stage();
        ball_make();
        move_syougai();
        detect_collision_syougai(); 
        test();
        cc();
    }
    else if (scene == "retry") {
        x = 200;
        y = 20;
        vx = 0;
        vy = 0;
        cc = 1;
        c = 0;
        tx = 0;
        ty = 0;
        scene = "start";
    }      
}

void photo_screen() {
    img = loadImage("ghost1.png");  //敵ゴースト
    rkd = loadImage("870414.jpg"); //背景:蜘蛛の巣
    jkd = loadImage("kazu2.png"); //炭酸水ロゴ
    tkd = loadImage("kazo6.png"); //ポイストロゴ
}

void game_start_screen() {
    fill(0);
    textSize(40);
    text("Please Press Enter", width/4.5, height/2 + 100);
    
    fill(255,0,0);
    textSize(80);
    text("Let's Start!!!!",width/8, height/2 + 200);
    
    fill(255);
    for (int i = 0; i < 60; i++) {
        noStroke();
        ellipse(desin_x[i],desin_y[i],15,15);
        desin_y[i] -= desin_speed[i]; 
        
        if (desin_y[i] < 0) {
            desin_x[i] = int(random(600));
            desin_y[i] = 850;
            desin_speed[i] = int(random(2,6));
        }
    }
}

void cc() {
    if (cc == 0) {
        ex -= distance / 15;
        if (ex <= 200) {
            ex = 200;
        }
        if (ex == 200) {
            if (c ==  0) {
                vx -= distance / 10;
                c = 1;
            }
            ball_move();
            time();
            touch_ball();
        }
    }
}

void make_stage() {
    background(0);
    tint(204,204,204);
    image(rkd,0,0,width,height);
    stroke(250);
    fill(255, 0,0);
    rect(0, height - 40, width, 40);
    fill(0);
    rect(0, 0, width, 10);
    rect(0, 0, 10, height - 40);
    rect(width - 10, 0, 10, height - 40);
    rect(0, height - 10, width, 10);
    rect(200, 50, width - 200, 10);
    for (int i = 0; i < 3; ++i) {
        fill(255, 0, 0);
        stroke(0);
        arc((float)gxl[i],(float)gyl[i],(float)grl[i] + 10,(float)grl[i] + 10, 0, PI, PIE);
        fill(0, 255,0);
        ellipse((float)gxl[i],(float)gyl[i],(float)grl[i],(float)grl[i]);
    }
    fill(0, 0, 0);
    textSize((int)grl[0] - 10);
    text(10, (float)gxl[0] - 20 , (float)gyl[0] + 10);
    textSize((int)grl[1] - 10);
    text(50, (float)gxl[1] - 5, (float)gyl[1] + 3);
    textSize((int)grl[2] - 10);
    text(30, (float)gxl[2] -13, (float)gyl[2] + 5);
}

void touch_ball() {
    for (int i = 0; i < 3; ++i) {
        if (gxl[i] - grl[i] < x && x < gxl[i] + grl[i]) {
            if (y >= gyl[i] - 20 && y < gyl[i]) {
                if (dist((float)x,(float)y,(float)gxl[i],(float)gyl[i]) < 20 + (float)grl[i]) {
                    ball_goal(i);
                } else {
                    mode = 1;
                    y = gyl[i] + 20;
                }
            }
        }
    }
}


void ball_goal(int i) {
    goal((int)gl[i]);
}

void goal(int g) {
    if (count < 4) {
        scene = "retry";
        count += 1;
        score += g;
    }
    else {
        background(255);
        image(rkd,0,0,width,height);
        textAlign(CENTER, CENTER);
        fill(#5AFF19);
        textSize(50);
        text("Your Score is " + score, 300, 200);
        stroke(#008833);
        strokeWeight(5);
        line(100,250,500,250);
        line(0,450,600,450);
        if (score == 0) {
            text("See you next time!", 300, 400);
        } else {
            if (250 < score) {
                freebie = "PS5";
            } else if (200 < score && score <= 250) {
                textSize(30);
                freebie = "Nintendo Switch";
            } else if (150 < score && score <= 200) {
                freebie = "earphone";
            } else if (100 < score && score <= 150) {
                textSize(30);
                freebie = "Doraemon figure";
            } else if (50 < score && score <= 100) {
                freebie = "candy";
            } else if (0 < score && score <= 50) {
                freebie = "Gum";
            }
            text("I give " + freebie + " for you !!!", 300, 400);
        }
        noLoop();
    }  
    
}

void ball_make() {
    fill(255,0,0);
    noStroke();
    ellipse((int)x,(int)y + 20, 20, 20);
}

void ball_move() {    
    x_coordinate_update();
    y_coordinate_update();
    
    x_inversion();
}

void x_coordinate_update() { //x座標の更新
    x += vx * tx;
}

void y_coordinate_update() { //y座標の更新
    if (mode == 0) {
        if (y + g * (ty + 0.01) * (ty + 0.01) / 2 >= height - 40) {
            goal(0);
            
        } else {
            vy = g * ty; //速度計算
            y += g * ty * ty / 2; //y座標の更新
        }
    } else if (mode == 1) {
        if ((y - vy0 * e * (ty + 0.01) - g * (ty + 0.01) * (ty + 0.01) / 2) 
            >= height - 40) {
            goal(0);
            
        } else {
            y -= vy0 * e * ty - g * ty * ty / 2; //y座標の更新
            if (vy0 * e >= g * ty) {
                vy = vy0 * e - g * ty;
            } else {
                
                vy = g * ty - vy0 * e;
            }
        }
    }
}

void x_initialVelocity() {
    
}

void x_inversion() { //x座標反転
    if (x + vx * (tx + 0.01) < 20) {
        x = 20;
        vx = -1 * vx * e;
    } else if (width - 20 < x + vx * (tx + 0.01)) {
        x = width - 20;
        vx = -1 * vx * e;
    }
}

void time() { //時間を進める
    ty += 0.01; 
    tx += 0.01;
}

void test() {
    point(200,40);
    fill(255,0,0);
    stroke(0);
    rect(ex, 15, 20, 40);
    //noStroke();
    stroke(255);
    line(ex, 40, 200, 40);
}

void start_scene() {
    textSize(50);
    fill(0);
    text("Start",width / 2 - 50, height / 2);
}

void mouseDragged() {//ボタンが押された状態でマウスが移動したときに呼び出される関数
    if (cc == 1) {
        ex = mouseX;  
    }  
}

void keyPressed() {
    if (key == ENTER) {
        scene = "game";
    }
}

void mouseReleased() {//マウスボタンから指が離れたときに呼び出される関数
    
    distance = int(sqrt(sq(200 - mouseX)));// + sq(40 - mouseY)));
    
    noFill();
    cc = 0;
}

void setup_syougai() {
    for (int i = 0;i < syougai_num;i++) {
        syougai_x[i] = random(r,width - r);
        if (syougai_x[i] < width / 2) {
            syougai_dx[i] = random(0.3,0.8);//ランダムの値を変える
        } else{
            syougai_dx[i] = random( -0.8, -0.3);
        }
        syougai_y[i] = height / (syougai_num + 1) * (i + 1) - r; 
    }
    
}
void move_syougai() { //障害の動き
    for (int i = 0;i < syougai_num;i++) {
        if (syougai_x[i] < r + 10) { //koko
            syougai_x[i] = r + 10;
            syougai_dx[i] *= -1;
        } else if (width - r - 10 < syougai_x[i]) { //koko
            syougai_x[i] = width - r - 10; 
            syougai_dx[i] *= -1;
        }
        syougai_x[i] += syougai_dx[i];
        tint(255);
        image(img,syougai_x[i],syougai_y[i],r * 2,r * 2);//ここを帰ることが出来る
    }
}

void detect_collision_syougai() {
    for (int i = 0;i < syougai_num;i++) {
        float d;
        d = dist(syougai_x[i],syougai_y[i],x,y);
        if (d <= 20) {
            stroke(0);
            syougai_x_inversion(i);
        }
    }
}

void syougai_x_inversion(int i) { 
    if (syougai_x[i] - x <= 20 & syougai_x[i] - x >=  0) { //koko
        vx = -1 * vx;
    } else if (x - syougai_x[i] >= -20 & x - syougai_x[i] < 0) { //koko
        vx = -1 * vx;
    }
}
