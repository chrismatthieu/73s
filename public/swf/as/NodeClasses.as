

/* ---------------------------------------------------------
   
	Person class 

--------------------------------------------------------- */




function Person() {
	this.radius=40;
	this.imageLoading=this.imageLoaded=false;
	
	this.clipLoader=new LoadingQueue();
}
Person.prototype = new Node();
Object.registerClass ("Person", Person);


Person.prototype.init=function (dataObj, viewManager){
	super.init(dataObj, viewManager);
	//this.loadPic();
	this.cacheAsBitmap=true;
};

Person.prototype.tweenFinished=function (){
	this.isBeingTweened=false;
	this.viewManager.layoutManager.aniFinished(this);
 	this.loadPic();
};

Person.prototype.loadPic=function (){
	//trace("loadPic "+this);
	if(!this.imageLoading && !this.imageLoaded){
		this.imageLoading=true;
		this.clipLoader.enqueue(this.imgPlaceHolder,this.imageURL, this);
	}
};

Person.prototype.onLoadInit=function (){
	//trace("Person.picLoaded "+this);
	this.imgPlaceHolder._width=this.nodeOutline._width;
	this.imgPlaceHolder._height=this.nodeOutline._height;
	this.imgPlaceHolder._yscale=this.imgPlaceHolder._xscale=Math.max(this.imgPlaceHolder._xscale, this.imgPlaceHolder._yscale);
	this.imgPlaceHolder._y=-this.imgPlaceHolder._height*.5;
	this.imgPlaceHolder._x=-this.imgPlaceHolder._width*.5;
	this.imageLoaded=true;
};

Person.prototype.onLoadError=function (){
	trace("Person.onLoadError "+this.name);
	this.imageLoaded=true;
};

Person.prototype.getDetails=function (){
	var d=[];
	d.push({label:"Name", value:this.name});
	d.push({label:"URL", value:this.URL, contentType:"URL"});
	d.push({label:"Hops", value:this.hops });
	return d;
};

