
/*
    Editable Image with Overlay
*/

var PMCanvas, PMEditableImage, PMLayers, PMPixel, PMWindow, PixelMixer,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

PMEditableImage = (function() {

  function PMEditableImage(img, pixMix) {
    this.img = img;
    this.pixMix = pixMix;
    this.hoverOut = __bind(this.hoverOut, this);
    this.hoverIn = __bind(this.hoverIn, this);
    this.wrap = __bind(this.wrap, this);
    if (this.img == null) return false;
    this.extension = this.img.src.slice(-3, img.src.length).toLowerCase();
    this.wrap(this.img);
    this.frames = [];
  }

  PMEditableImage.prototype.wrap = function(img) {
    var _this = this;
    this.img = img;
    this.width = $(this.img).width();
    this.height = $(this.img).height();
    this.wrapper = $("<div/>");
    this.wrapper.addClass("pixMix_wrapper").attr("style", "width:" + this.width + "px;height:" + this.height + "px;");
    this.wrapper.append("<div class=\"pixMix_imageDiv\" style=\"width:" + this.width + "px;height:" + this.height + "px;\">" + this.img.outerHTML + "</div>");
    this.overlay = $("<div/>");
    this.overlay.addClass("pixMix_overlay").attr("style", "width:" + this.width + "px;height:" + this.height + "px;");
    this.wrapper.append(this.overlay);
    this.overlay.hide();
    $(this.wrapper).mouseenter(function() {
      return _this.hoverIn();
    });
    $(this.wrapper).mouseleave(function() {
      return _this.hoverOut();
    });
    $(this.wrapper).click(function() {
      return _this.pixMix.loadImg(_this);
    });
    return $(this.img).replaceWith(this.wrapper);
  };

  PMEditableImage.prototype.hoverIn = function() {
    this.wrapper.toggleClass("pixMix_wrapper_selected", true);
    return this.overlay.fadeIn(0.6);
  };

  PMEditableImage.prototype.hoverOut = function(evt) {
    this.wrapper.toggleClass("pixMix_wrapper_selected", false);
    return this.overlay.fadeOut(0.3);
  };

  return PMEditableImage;

})();

/* -------------------------------------------- 
    Begin PMCanvas.coffee 
--------------------------------------------
*/

/*
    Canvas Class
*/

PMCanvas = (function() {

  function PMCanvas(domElement, n, pixMix) {
    this.domElement = domElement;
    this.pixMix = pixMix;
    this.pixelAtPoint = __bind(this.pixelAtPoint, this);
    this.loadAnimation = __bind(this.loadAnimation, this);
    this.loadStill = __bind(this.loadStill, this);
    this.update = __bind(this.update, this);
    this.load = __bind(this.load, this);
    if (this.domElement == null) {
      if (typeof image === "undefined" || image === null) {
        this.canvas = $("<canvas>").attr("width", window.innerWidth / 3).attr("height", window.innerHeight / 3);
      } else {
        if (image.width < window.innerWidth / 2 && image.height < window.innerHeight / 2) {
          this.canvas = $("<canvas>").attr("width", image.width).attr("height", image.height);
        }
      }
    } else {
      this.width = $(this.domElement).width();
      this.height = $(this.domElement).height();
      if (this.width < 500) this.width = 500;
      if (this.height < 500) this.height = 500;
      this.canvas = $("<canvas>").attr("width", this.width).attr("height", this.height);
      this.canvas.css("position", "absolute").css("z-index", n);
      this.domElement.append(this.canvas);
    }
    this.zoom = this.pixMix.zoom;
    this.ctx = this.canvas[0].getContext("2d");
    this.loader = this.pixMix.loader;
  }

  PMCanvas.prototype.load = function(img, loader) {
    this.img = img;
    this.loader = loader;
    this.left = (this.width - this.img.width * this.zoom) / 2;
    this.top = (this.height - this.img.height * this.zoom) / 2;
    if (this.left < 0) this.left = 0;
    if (this.top < 0) this.top = 0;
    this.ctx.fillStyle = "#fff";
    this.ctx.fillRect(0, 0, this.width, this.height);
    if (this.img.extension === "gif") {
      return this.loadAnimation(this.img);
    } else {
      return this.loadStill(this.img);
    }
  };

  PMCanvas.prototype.update = function(pixel) {
    if (pixel != null) {
      this.ctx.fillStyle = pixel.hexColor();
      return this.ctx.fillRect(this.left + pixel.x * this.zoom, this.top + pixel.y * this.zoom, 1 * this.zoom, 1 * this.zoom);
    }
  };

  PMCanvas.prototype.loadStill = function(img) {
    var i, imgd, pix, pixel, x, y, _ref, _results;
    this.img = img;
    this.loader.drawImage(this.img.img, 0, 0);
    imgd = this.loader.getImageData(0, 0, this.img.width, this.img.height);
    pix = imgd.data;
    this.pixels = [];
    x = 0;
    y = 0;
    _results = [];
    for (i = 0, _ref = pix.length; i < _ref; i += 4) {
      x++;
      if (x > this.img.width) {
        x = x - this.img.width;
        y++;
      }
      pixel = new PMPixel(pix[i], pix[i + 1], pix[i + 2], pix[i + 3], x, y);
      this.ctx.fillStyle = pixel.hexColor();
      this.ctx.fillRect(this.left + x * this.zoom, this.top + y * this.zoom, 1 * this.zoom, 1 * this.zoom);
      _results.push(this.pixels.push(pixel));
    }
    return _results;
  };

  PMCanvas.prototype.loadAnimation = function(img) {
    return this.loadStill(img);
  };

  PMCanvas.prototype.pixelAtPoint = function(point) {
    var realX, realY;
    if (point.x > this.left) realX = Math.floor((point.x - this.left) / this.zoom);
    if (point.y > this.top) realY = Math.floor((point.y - this.top) / this.zoom);
    if ((realX != null) && (realY != null)) {
      return this.pixels[(this.img.width * realY + realX) - 1];
    }
  };

  return PMCanvas;

})();

/* -------------------------------------------- 
    Begin PMWindow.coffee 
--------------------------------------------
*/

PMWindow = (function() {

  function PMWindow() {
    $("<div>")["class"]("pixMix_window");
  }

  return PMWindow;

})();

/* -------------------------------------------- 
    Begin PMPixel.coffee 
--------------------------------------------
*/

PMPixel = (function() {

  PMPixel.red;

  PMPixel.green;

  PMPixel.blue;

  PMPixel.alpha;

  PMPixel.x;

  PMPixel.y;

  function PMPixel(red, green, blue, alpha, x, y) {
    this.red = red;
    this.green = green;
    this.blue = blue;
    this.alpha = alpha;
    this.x = x;
    this.y = y;
    this.lighten = __bind(this.lighten, this);
    this.darken = __bind(this.darken, this);
    this.toHex = __bind(this.toHex, this);
    this.hexColor = __bind(this.hexColor, this);
  }

  PMPixel.prototype.hexColor = function() {
    var rgb;
    rgb = "#" + this.toHex(this.red) + this.toHex(this.green) + this.toHex(this.blue);
    return rgb;
  };

  PMPixel.prototype.toHex = function(n) {
    n = parseInt(n, 10);
    if (isNaN(n)) return "00";
    n = Math.max(0, Math.min(n, 255));
    return "0123456789ABCDEF".charAt((n - n % 16) / 16) + "0123456789ABCDEF".charAt(n % 16);
  };

  PMPixel.prototype.darken = function(amount) {
    this.red -= amount;
    this.green -= amount;
    return this.blue -= amount;
  };

  PMPixel.prototype.lighten = function(amount) {
    this.red += amount;
    this.green += amount;
    return this.blue += amount;
  };

  return PMPixel;

})();

/* -------------------------------------------- 
    Begin PMLayers.coffee 
--------------------------------------------
*/

PMLayers = (function() {

  function PMLayers(container, pixMix) {
    this.container = container;
    this.pixMix = pixMix;
    this.update = __bind(this.update, this);
    this.add = __bind(this.add, this);
    this.length = 0;
    this.tools = new PMCanvas(this.container, 50, this.pixMix);
  }

  PMLayers.prototype.add = function() {
    var layer;
    layer = new PMCanvas(this.container, this.length, this.pixMix);
    this["l" + this.length] = layer;
    return this.update();
  };

  PMLayers.prototype.update = function() {
    var i, prop;
    i = 0;
    for (prop in this) {
      if (prop.slice(0, 1) === "l" && prop.length < 4) i++;
    }
    return this.length = i;
  };

  return PMLayers;

})();

/* -------------------------------------------- 
    Begin PixelMixer.coffee 
--------------------------------------------
*/

/*
    Main PixelMixer Class
*/

PixelMixer = (function() {

  /*
          main Configuration
          attr {
              scope: "page" |  "#containerIds" | ".containerClass"
              container: "containerId" | floating
              width: xxx
              height: yyy
              zoom: true | false
              onload: true | false
          }
  */

  PixelMixer.scope;

  PixelMixer.container;

  PixelMixer.width;

  PixelMixer.height;

  PixelMixer.zoom;

  PixelMixer.layers;

  PixelMixer.imgs;

  function PixelMixer(attr) {
    this.makeEditable = __bind(this.makeEditable, this);
    this.prepareImgs = __bind(this.prepareImgs, this);
    this.loadImg = __bind(this.loadImg, this);
    this.eventToPoint = __bind(this.eventToPoint, this);
    this.mouseUp = __bind(this.mouseUp, this);
    this.mouseDown = __bind(this.mouseDown, this);
    this.mouseOver = __bind(this.mouseOver, this);
    var scope,
      _this = this;
    this.isMouseDown = false;
    this.zoom = 1;
    if (attr != null) {
      if ($.type(attr) === "object") {
        if ((attr.scope != null) && $.type(attr.scope) === "string") {
          if (attr.scope.substr(0, 1) === "#" || attr.scope.substr(0, 1) === ".") {
            scope = attr.scope + " img";
            this.scope = $(scope);
          } else if (attr.scope === "page") {
            this.scope = $("img");
          }
        } else {
          this.scope = $("img");
        }
        if ((attr.onload != null) && $.type(attr.onload) === "boolean") {
          this.onload = attr.onload;
        } else {
          this.onload = true;
        }
        if (attr.container != null) {
          this.container = $(attr.container);
          this.container.attr("width", "500");
          this.container.attr("height", "500");
          this.container.css("position", "relative");
        }
      }
    } else {
      this.scope = $("img");
      this.onload = true;
    }
    this.imgs = new Array();
    if (this.onload != null) {
      $(window).load(function() {
        return _this.prepareImgs(_this.scope);
      });
    } else {
      this.prepareImgs(this.scope);
    }
    this.loaderElm = document.createElement("canvas");
    this.loaderElm.setAttribute("width", this.container.attr("width"));
    this.loaderElm.setAttribute("height", this.container.attr("height"));
    this.loader = this.loaderElm.getContext("2d");
    this.layers = new PMLayers(this.container, this);
    this.layers.add();
    this.container.bind("mousemove", function(event) {
      return _this.mouseOver(event);
    });
    this.container.bind("mousedown", function(event) {
      return _this.mouseDown(event);
    });
    this.container.bind("mouseup", function(event) {
      return _this.mouseUp(event);
    });
  }

  PixelMixer.prototype.mouseOver = function(evt) {
    var pixel;
    this.container[0].style.cursor = 'crosshair';
    if (this.isMouseDown) {
      pixel = this.pixelAtPoint(this.eventToPoint(evt));
      if (pixel != null) {
        pixel.darken(20);
        return this.update(pixel);
      }
    }
  };

  PixelMixer.prototype.mouseDown = function(evt) {
    var pixel;
    this.container[0].style.cursor = 'crosshair';
    this.isMouseDown = true;
    pixel = this.pixelAtPoint(this.eventToPoint(evt));
    if (pixel != null) {
      pixel.darken(20);
      return this.update(pixel);
    }
  };

  PixelMixer.prototype.mouseUp = function(evt) {
    return this.isMouseDown = false;
  };

  PixelMixer.prototype.eventToPoint = function(event) {
    var point;
    return point = {
      x: event.pageX - this.container.offset().left,
      y: event.pageY - this.container.offset().top
    };
  };

  PixelMixer.prototype.loadImg = function(img) {
    return this.layers.l0.load(img, this.loader);
  };

  PixelMixer.prototype.prepareImgs = function(scope) {
    var _this = this;
    return scope.each(function(i, img) {
      return _this.makeEditable(img);
    });
  };

  PixelMixer.prototype.makeEditable = function(img) {
    var imageEdit;
    imageEdit = new PMEditableImage(img, this);
    if (imageEdit != null) return this.imgs.push(imageEdit);
  };

  return PixelMixer;

})();
