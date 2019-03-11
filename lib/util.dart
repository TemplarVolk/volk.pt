import 'dart:html';
import 'package:vector2/vector2.dart';
import 'dart:math' as Math;

class Point {
  
  int size;
  int type;

  String color;
  String character;
  String font;

  Vector2 position;
  Vector2 startPosition;

  ParticleImage canvas;

  Point(ParticleImage this.canvas, int this.size, String this.color, Vector2 this.position, Vector2 this.startPosition, this.type, {this.character}) {
    this.font = '${this.size}px Permanent Marker';
  }

  void update() {
    canvas.repulse(this.position, startPosition, canvas.mouse, canvas.threshold, 2);
  }
}

class ParticleImage {
  
  CanvasElement canvas;
  CanvasRenderingContext2D ctx;
  Vector2 mouse;
  Vector2 userMouse;
  Vector2 center;
  bool hover;
  int step = 3;
  int threshold = 150;
  double repulsion = 0.1;
  ImageData imageData;
  List<Point> points = [];

  String id;
  String source;

  static const int PIXEL = 0;
  static const int CHAR = 1;
  static const int LINE = 2;
  static const int ARROW = 3;

  ParticleImage(String this.id, String this.source);

  Future<ParticleImage> init() async {
    this.canvas = document.getElementById('me');

    ctx = this.canvas.getContext("2d");

    this.canvas.addEventListener('mousemove', this.mouseHandler);
    this.canvas.addEventListener('mouseout', this.mouseHandler);
    window.addEventListener('resize', this.resize);

    
    this.hover = false;

    ImageElement image = new ImageElement(src: this.source);

    await image.onLoad.first;

    this.ctx.drawImageScaled(image, 0, 0, 600, 600);

    this.imageData = ctx.getImageData(0, 0, 600, 600);

    this.resize();
    this.loop();

    return this;
  }


  void mouseHandler(e) {
    this.hover = e.type == 'mousemove';
    this.userMouse.x = e.client.x;
    this.userMouse.y = e.client.y;
  }

  void createGrid() {
    this.points = [];

    for (var i = 0; i < 600; i += this.step) {
      for (var j = 0; j < 600; j += this.step) {
        if (this.imageData.data[j * (600 * 4) + i * 4 + 3] != 0) {
        Vector2 vec = new Vector2((window.innerWidth/2-300 + i).ceil().toDouble(), (window.innerHeight/2-150 + j).ceil().toDouble());
        this.points.add(new Point(
            this,
            4,
            "rgb(${this.imageData.data[j * (600 * 4) + i * 4]}, ${this.imageData.data[j * (600 * 4) + i * 4 + 1]}, ${this.imageData.data[j * (600 * 4) + i * 4 + 2]})",
            vec,
            vec.clone(),
            ParticleImage.PIXEL
          ));
        }
      }
    }
  }

  void draw() {
    if (!hover) this.threshold = 0;
    else this.threshold = 150;
    this.mouse = userMouse;
    this.ctx.clearRect(0, 0, this.canvas.width, this.canvas.height);
    for (var i = 0, len = points.length; i < len; i++) {
      Point p = this.points[i];
      p.update();

      if (p.position.x - p.size / 2 < 0) {
        p.position.x = p.size / 2;
      } else if (p.position.x + p.size / 2 > window.innerWidth) {
        p.position.x = window.innerWidth - p.size / 2;
      }

      if (p.position.y - p.size < 0) {
        p.position.y = p.size.toDouble();
        print(p.position.y);
      } else if (p.position.y + p.size / 2 > window.innerHeight) {
        p.position.y = window.innerHeight - p.size / 2;
      }

      this.ctx.fillStyle = p.color;

      if (p.type == ParticleImage.CHAR) {
        this.ctx.font = p.font;
        this.ctx.fillText(p.character, p.position.x - p.size / 2, p.position.y - p.size / 2);
      } else if (p.type == ParticleImage.LINE) {
        this.ctx.strokeStyle = p.color;
        this.ctx.lineWidth = p.size;

        ctx.beginPath();
        ctx.moveTo(p.position.x, p.position.y);
        ctx.quadraticCurveTo(p.startPosition.x + 64, p.startPosition.y, p.position.x + 96, p.position.y + 128);
        ctx.stroke();
      } else if (p.type == ParticleImage.ARROW) {
        this.ctx.strokeStyle = p.color;
        this.ctx.lineWidth = p.size;

        ctx.beginPath();
        ctx.moveTo(p.position.x, p.position.y);
        ctx.quadraticCurveTo(p.startPosition.x + 20, p.startPosition.y + 30, p.position.x + 20, p.position.y - 10);
        ctx.stroke();
      } else {
        this.ctx.fillRect(p.position.x - p.size / 2, p.position.y - p.size / 2, p.size, p.size);
      }
      this.ctx.restore();
    }
  }

  void loop([_]) {
    this.draw();
    window.requestAnimationFrame(loop);
  }

  void resize([_]) {
    this.canvas.width = window.innerWidth;
    this.canvas.height = window.innerHeight;

    this.center = new Vector2(this.canvas.width / 2, this.canvas.height / 2);
    this.mouse = new Vector2(this.center.x, this.center.y);
    this.userMouse = new Vector2(this.center.x, this.center.y);

    this.createGrid();
  }

  void repulse(vec, start, from, base, ex){
    vec.x += ((Math.cos(from.angleTo(vec)) * (Math.pow(base, ex) / vec.distanceTo(from))) + (start.x - vec.x)) * this.repulsion;
    vec.y += ((Math.sin(from.angleTo(vec)) * (Math.pow(base, ex) / vec.distanceTo(from))) + (start.y - vec.y)) * this.repulsion;
  }
}

addVectors(canvas) {

  Vector2 vec = new Vector2(window.innerWidth/2-300 + 48, window.innerHeight/2-250 - 24);
  canvas.points.insert(0, new Point(
    canvas,
    3,
    "#ccc",
    vec,
    vec.clone(),
    ParticleImage.LINE
  ));

  Vector2 vec2 = new Vector2(window.innerWidth/2-300 + 133, window.innerHeight/2-250 + 96);
  canvas.points.insert(0, new Point(
    canvas,
    3,
    "#ccc",
    vec2,
    vec2.clone(),
    ParticleImage.ARROW
  ));

  createVectorText(canvas, "me", window.innerWidth/2-284, window.innerHeight/2-250, size: 32, color: "#ccc");
  createVectorText(canvas, "VOLK", window.innerWidth / 2, 150, size: 96);
  createVectorText(canvas, "I still don't know what do with this domain :DDD", window.innerWidth / 2, window.innerHeight.toDouble(), size: 16);
}

createVectorText(ParticleImage canvas, String text, double centerX, double y, {size: 13, color: "#11100e"}) {
  for (var i = 0; i < text.length; i++) {
    double distance;
    if (i+1 <= text.length/2) {
      distance = -(text.length/2-(i+1))*size - size/2;
    } else {
      distance = (i-text.length/2)*size + size/2;
    }

    Vector2 vec = new Vector2(centerX + distance, y);
    canvas.points.insert(0, new Point(
      canvas,
      size,
      color,
      vec,
      vec.clone(),
      ParticleImage.CHAR,
      character: text[i]
    ));
  }
}

// TODO: Move this function to the index component
init() async {
  ParticleImage canvas = await new ParticleImage('#me', 'public/images/me.png').init();

  addVectors(canvas);

  window.addEventListener('resize', (e) {
    canvas.points.removeWhere((point) => point.type != null && point.type != ParticleImage.PIXEL);
    addVectors(canvas);    
  });
  
}

String bytesTo64(bytes){
  String binary = '';
  for (int i = 0; i < bytes.length; i++) {
    binary += String.fromCharCode( bytes[ i ] );
  }
  return window.btoa(binary);
}
