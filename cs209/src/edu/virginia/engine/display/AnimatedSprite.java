package edu.virginia.engine.display;

import edu.virginia.engine.util.GameClock;

import java.awt.*;
import java.awt.image.BufferedImage;
import java.util.ArrayList;
import edu.virginia.engine.display.Animation;

public class AnimatedSprite extends DisplayObjectContainer {

	private String fileName;

	private ArrayList<Animation> animations;

	private ArrayList<BufferedImage> frames;

	private boolean playing;

	private int currentFrame;

	private int startFrame;

	private int endFrame;

	private GameClock gameClock;

	private double animationSpeed;

	static final double DEFAULT_ANIMATION_SPEED = 200;

	public AnimatedSprite(String id, String imageFileName) {
		super(id, imageFileName);
		animationSpeed = DEFAULT_ANIMATION_SPEED;
		gameClock = new GameClock();
		playing = false;
		frames = new ArrayList<BufferedImage>();
		animations = new ArrayList<Animation>();
		startFrame = 0;
		setAnimations(new Animation("left_move", 2, 3));
		setAnimations(new Animation("right_move", 0, 1));
		initializeFrames("mario_walk", 0, 3);
	}

	public void initGameClock(){
		if(gameClock != null){
			gameClock = new GameClock();
		}
	}

	public double getAnimationSpeed() { return animationSpeed; }

	public void setAnimationSpeed(double animationSpeed){
		this.animationSpeed = animationSpeed;
	}

	public void setAnimations(Animation animation){
		this.animations.add(animation);
	}

	public void setPlaying(boolean playing){
		this.playing = playing;
	}

	@Override
	public void draw(Graphics g){
		if(playing && (gameClock.getElapsedTime() > animationSpeed)){
			currentFrame += 1;
			if(currentFrame > endFrame){
				currentFrame = startFrame;
			}
			super.setImage(frames.get(currentFrame));
			initGameClock();
		}
		super.draw(g);
	}

	public void initializeFrames(String imageFileName, int startFrame, int endFrame) {
		for(int i = startFrame; i <= endFrame; i++){
			String fileName = imageFileName + "_" + i + ".png";
			BufferedImage displayImage = readImage(fileName);
			if (displayImage == null) {
				System.err.println("[DisplayObject.setImage] ERROR: " + fileName + " does not exist!");
			}
			frames.add(displayImage);
		}
	}

	public Animation getAnimation(String id){
		Animation result = null;
		for (Animation anim : animations)
		{
			if(anim.getId().equals(id)){
				result = anim;
			}
		}
		return result;
	}

	public void animate(int startFrame, int endFrame){
		playing = true;
		this.startFrame = startFrame;
		this.endFrame = endFrame;
	}

	public void animate(Animation animation){
		playing = true;
		this.startFrame = animation.getStartFrame();
		this.endFrame = animation.getEndFrame();
	}

	public void animate(String id){
		Animation animation = getAnimation(id);
		if(animation != null) {
			animate(animation);
		}
	}

	public void stopAnimation(int frameNumber){
		playing = false;
		super.setImage(frames.get(frameNumber));
	}

	public void stopAnimation(){
		stopAnimation(0);
	}
}
