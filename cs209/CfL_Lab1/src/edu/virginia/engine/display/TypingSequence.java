package edu.virginia.engine.display;

import java.awt.*;
import java.util.ArrayList;


/**
 * A very basic display object for a java based gaming engine
 * 
 * */
public class TypingSequence extends DisplayObject {

	/* A list of DisplayObject objects that are the children of this container */
	private ArrayList<Character> letters;
	private int interval;
	private Point target;
	private Point origin;
	private boolean attack;

	private char result;
	private int currentTime;
	private int stage;
	private boolean letterReleased;
	private boolean active;

	private int prev_key;

	private String sfxString;
    private String damageString;
	private String typeString;

	/**
	 * Constructors: can pass in the id OR the id and image's file path and
	 * position OR the id and a buffered image and position
	 */
	public TypingSequence(String id, int interval) {
		super(id);
		super.setVisibility(false);
		this.interval = interval;

		this.result = 'n';
		letters = new ArrayList<Character>();
		this.target = new Point();
		this.origin = new Point();
		stage = 0;
		letterReleased = true;
		active = false;
		currentTime = 0;
		prev_key = -1;
	}

	public TypingSequence(String id, String fileName, int interval, String sfxString, String damageString, String typeString) {
		super(id, fileName);
		super.setVisibility(false);
		this.interval = interval;
		this.sfxString = sfxString;
		this.damageString = damageString;
		this.typeString = typeString;

		this.result = 'n';
		letters = new ArrayList<Character>();
		this.target = new Point();
		this.origin = new Point();
		stage = 0;
		letterReleased = true;
		active = false;
		currentTime = 0;
		prev_key = -1;
	}

	/* Returns the ArrayList of children */
	public ArrayList<Character> getLetters() { return letters; }

	public void setLetters(ArrayList<Character> letters) { this.letters = letters; }

	public boolean getActive() { return active; }

	public void setActive(boolean active) { this.active = active; }

	public boolean getAttack() { return attack; }

	public void setAttack(boolean attack) { this.attack = attack; }

    public String getSfxString() { return sfxString; }

    public void setSfxString(String sfxString) { this.sfxString = sfxString; }

    public String getDamageString() { return damageString; }

    public void setDamageString(String damageString) { this.damageString = damageString; }

	public String getTypeString() { return typeString; }

	public void setTypeString(String typeString) { this.typeString = typeString; }

	public void setTarget(Point target){ this.target = target; }

	public Point getTarget() { return target; }

	public void setOrigin(Point origin){ this.origin = origin; }

	public Point getOrigin() { return origin; }

	public int getResult() { return result; }

	public void start(){
		super.setPosition(origin);
		currentTime = 0;
		stage = 0;
		letterReleased = true;
		super.setVisibility(true);
		active = true;
		result = 'n';
		prev_key = -1;
	}

	public Character getCurrentLetter(){
		if(stage < letters.size()){
			return letters.get(stage);
		} else {
			return null;
		}
	}

	/* Add a letter to the end of the ArrayList */
	public void addLetter(Character letter){
		letters.add(letter);
	}

	/* Add a letter at index i */
	public void addLetterAtIndex(Character letter, int i){
		letters.add(i, letter);
	}

	/* Remove letter at index i */
	public void removeByIndex(int i){
		letters.remove(i);
	}

	/* Remove all letters from the ArrayList */
	public void removeAll(){
		letters = new ArrayList<Character>();
	}

	protected void update(ArrayList<Integer> pressedKeys) {
		currentTime += 1;
		int overall = letters.size() * interval;

//		System.out.println(super.getId() + ": " + currentTime);

		Character cur_letter = getCurrentLetter();
		if(!letterReleased && !pressedKeys.contains(prev_key)){
			letterReleased = true;
//			System.out.println("Key released");
		}
		if(cur_letter != null){
			int keyCode = java.awt.event.KeyEvent.getExtendedKeyCodeForChar(cur_letter);
//			System.out.println("Current letter: " + getCurrentLetter());
//			System.out.println("Key released: " + letterReleased);
			if(pressedKeys.contains(keyCode) && pressedKeys.size() == 1 && letterReleased) {
				letterReleased = false;
				prev_key = keyCode;
				stage += 1;
//				System.out.println("Correct key press");
			} else if(pressedKeys.contains(prev_key) && pressedKeys.size() == 1 && !letterReleased){
				// Don't fail - do nothing. But will fail if double tap
			} else if(pressedKeys.size() > 0) {
//				System.out.println("Incorrect key press");
				result = 'f';
			}
		} else {
			if(pressedKeys.size() > 0 && letterReleased) {
//				System.out.println("Incorrect key press");
				result = 'f';
			}
			result = 's';
		}

		if(currentTime >= overall){
			result = 'f';
		}
	}

	@Override
	public void draw(Graphics g) {
		if(active){
			super.draw(g);
		}
	}

}
