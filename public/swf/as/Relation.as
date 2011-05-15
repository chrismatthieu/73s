
Relation.prototype.draw = function(){

	if(this.fromMC==null || this.toMC==null){
		this.remove();
		delete this;
		return;
	} 
		
	this.updateCoords();

	if(this.toMC.isInCenter || this.fromMC.isInCenter){

		this.drawTarget.lineStyle (this.lineSize, this.color, 100);
		this.drawTarget.moveTo (this.fromX, this.fromY);
		this.drawTarget.lineTo (this.toX, this.toY);

	} else if(!this.viewManager.layoutManager.tooManyNodes){
		
		// CONNECTION TO OTHER CLIP
		
		var diffX=this.toXCenter-this.fromXCenter;
		var diffY=this.toYCenter-this.fromYCenter;
		var l=Math.sqrt(diffX*diffX + diffY*diffY);
		var l2=l/3;
		
		diffX=diffX/l;
		diffY=diffY/l;
		var nX=-diffY;
		var nY=diffX;
		
		var curveX=this.middleX+nX*l2;
		var curveY=this.middleY+nY*l2;
		
		if((curveX*curveX + curveY*curveY)<(this.middleX*this.middleX+this.middleY*this.middleY)){
			curveX=this.middleX-nX*l2;
			curveY=this.middleY-nY*l2;
			
		}
		
		this.drawTarget.lineStyle (1, 0x000000, 14);
		this.drawTarget.moveTo (this.fromXCenter, this.fromYCenter);
		this.drawTarget.curveTo(curveX, curveY,this.toXCenter, this.toYCenter);
	}
};
