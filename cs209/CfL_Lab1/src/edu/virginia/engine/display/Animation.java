package edu.virginia.engine.display;

import edu.virginia.engine.util.GameClock;

import java.awt.*;

public class Animation {
	/* Name of this animation */
	private String id;

	/* Index of the start frame in the list of images */
	private int startFrame;

	/* Index of the last frame in the list of images */
	private int endFrame;

	public Animation(String id, int startFrame, int endFrame) {
		this.id = id;
		this.startFrame = startFrame;
		this.endFrame = endFrame;
	}

	public String getId(){
		return id;
	}

	public void setId(String id){
		this.id = id;
	}

	public int getStartFrame(){
		return startFrame;
	}

	public void setStartFrame(int startFrame){
		this.startFrame = startFrame;
	}

	public int getEndFrame(){
		return endFrame;
	}

	public void setEndFrame(int endFrame){
		this.endFrame = endFrame;
	}

}
