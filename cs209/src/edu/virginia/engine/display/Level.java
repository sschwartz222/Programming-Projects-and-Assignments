package edu.virginia.engine.display;

import java.awt.*;
import java.util.ArrayList;

/**
 * A very basic display object for a java based gaming engine
 * 
 * */
public class Level extends DisplayObject {

	/* A list of DisplayObject objects that are the children of this container */
	private ArrayList<TypingSequence> sequences;
	private ArrayList<Integer> probabilities;
	private TypingSequence currentSequence = null;

	private boolean active;
	int interval;
	int currentTime;

	SoundManager sounds;

	private int offset;

	/**
	 * Constructors: can pass in the id OR the id and image's file path and
	 * position OR the id and a buffered image and position
	 */
	public Level(String id, int interval, SoundManager sounds) {
		super(id);
		sequences = new ArrayList<TypingSequence>();
		probabilities = new ArrayList<Integer>();
		active = false;
		this.sounds = sounds;

		this.interval = interval;
		currentTime = 0;
	}

	public boolean getActive() {return active;}

	public void setActive(boolean active){ this.active = active; }

	public ArrayList<TypingSequence> getSequences() { return sequences; }

	public void setSequences(ArrayList<TypingSequence> seq) { sequences = seq; }

	public ArrayList<Integer> getProbabilities() { return probabilities; }

	public void setProbabilities(ArrayList<Integer> probabilities) { this.probabilities = probabilities; }

	public TypingSequence getCurrentSequence() { return currentSequence; }

	/* Get sequence with a specific id */
	public TypingSequence getSequence(String id){
		for(TypingSequence seq : sequences){
			if(seq.getId() == id){
				return seq;
			}
		}
		return null;
	}

	public void updateTime(ArrayList<Integer> pressedKeys){
		if(active){
			if(currentSequence == null || !currentSequence.getActive()) {
				int new_seq = (int)(Math.random() * 100);
				int total = 0;
				int i;
				for(i = 0; i < probabilities.size(); i++) {
					total += probabilities.get(i);
					if(new_seq < total) {
						break;
					}
				}
				currentSequence = sequences.get(i);
				currentSequence.start();
				currentTime = 0;
				sounds.PlaySoundEffect(currentSequence.getTypeString());
				System.out.println("Done picking new sequence: " + currentSequence.getId());
			}
			if(currentSequence != null && currentSequence.getActive()){
				currentSequence.update(pressedKeys);
			}
			if(currentSequence.getResult() != 'n' && currentSequence.getActive()) {
				if(currentTime == 0) {
					if((currentSequence.getResult() == 'f' && currentSequence.getAttack())
							|| (currentSequence.getResult() == 's' && !currentSequence.getAttack())){
						double above = Math.random();
						if (above > 0.5){
							offset = 200;
						} else {
							offset = -200;
						}
					} else {
						offset = 0;
					}
					sounds.PlaySoundEffect(currentSequence.getSfxString());
				}
				if(currentTime == 25){
					if(offset == 0){
						sounds.PlaySoundEffect(currentSequence.getDamageString());
					}
				}
				currentTime += 1;
				Point target = new Point(currentSequence.getTarget().x,  currentSequence.getTarget().y + offset);
				Point origin = currentSequence.getOrigin();
				int xDistance = (int)((double)(target.x - origin.x) * ((double) (currentTime) / interval));
				int yDistance = (int)((double)(target.y - origin.y) * ((double) (currentTime) / interval));
				currentSequence.setPosition(new Point (origin.x + xDistance, origin.y + yDistance));
				if(currentTime >= interval){
					currentSequence.setActive(false);
				}
			}
		}
	}

	protected void update(ArrayList<Integer> pressedKeys) {

	}
}
