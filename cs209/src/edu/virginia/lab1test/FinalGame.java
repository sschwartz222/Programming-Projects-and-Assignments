package edu.virginia.lab1test;

import edu.virginia.engine.display.DisplayObject;
import edu.virginia.engine.display.Game;
import edu.virginia.engine.display.SoundManager;
import edu.virginia.engine.display.TypingSequence;
import edu.virginia.engine.display.Level;

import java.awt.*;
import java.awt.event.KeyEvent;
import java.awt.geom.Ellipse2D;
import java.util.ArrayList;

/**
 * Example game that utilizes our engine. We can create a simple prototype game with just a couple lines of code
 * although, for now, it won't be a very fun game :)
 * */
public class FinalGame extends Game{

	/* Create a sprite object for our game. We'll use mario */
	DisplayObject menu = new DisplayObject("menu", "menu.jpg");
	DisplayObject background_forest = new DisplayObject("forest", "forest.png");
	DisplayObject background_castle = new DisplayObject("castle", "castle.jpg");
	DisplayObject background_hallway = new DisplayObject("hallway", "hallway.jpg");
	DisplayObject player = new DisplayObject("Player", "sprite.png");
	DisplayObject slime = new DisplayObject("Slime", "slime.png");
	DisplayObject knight = new DisplayObject("Knight", "warrior.png");
	DisplayObject goblin = new DisplayObject("Goblin", "goblin.png");

	DisplayObject fairy = new DisplayObject("Fairy", "fairy.png");
	DisplayObject player_story = new DisplayObject("Player Story", "sprite.png");
	DisplayObject knight_story = new DisplayObject("Knight Story", "warrior.png");

	DisplayObject health_pot = new DisplayObject("Health Potion", "health_potion.png");
	DisplayObject damage_pot = new DisplayObject("Damage Potion", "damage_potion.png");

	DisplayObject black_screen = new DisplayObject("Screen", "black_screen.png");

    TypingSequence fireball = new TypingSequence("Fireball", "fireball.png", 120, "fireball", "en10", "f");
	TypingSequence waterball = new TypingSequence("Waterball", "waterball.png", 80, "water", "en10", "for");
	TypingSequence big_fireball = new TypingSequence("Big Fireball", "fireball.png", 120, "fireball", "en25", "d");
	TypingSequence enemy_fireball = new TypingSequence("Enemy Fireball", "enemy_fireball.png", 80, "fireball", "p10", "if");
	TypingSequence big_enemy_fireball = new TypingSequence("Big Enemy Fireball", "enemy_fireball.png", 80, "fireball", "p15", "joy");
	TypingSequence slimeball = new TypingSequence("Slimeball", "slimeball.png", 120, "slime", "p2", "j");
	TypingSequence lightning = new TypingSequence("Lightning", "lightning.png", 80, "elec", "en10", "of");
	TypingSequence big_lightning = new TypingSequence("Big Lightning", "lightning.png", 80, "elec", "en20", "art");
	TypingSequence spear = new TypingSequence("Spear", "spear.png", 80, "spear", "p15", "pool");
	TypingSequence spear_pink = new TypingSequence("Spear Pink", "spear_pink.png", 80, "spear", "p10", "sad");

	int player_health = 100;
	int enemy_health = 100;

	int starting_level = 1;

	boolean key_pressed = false;
	boolean key_space_pressed = false;
	boolean d_key_pressed = false;

	boolean preLevel1 = false;
	boolean postLevel1 = false;
	boolean preLevel2 = false;
	boolean postLevel2 = false;
	boolean preLevel3 = false;
	boolean postLevel3 = false;
	int timer = 0;
	int stage = 0;

	int health_potions = 0;
	int damage_potions = 0;
	int potion_timer = 0;

	boolean decision = false;
	boolean on_menu = true;
	boolean village = false;

	String text = "";
	String text2 = "";

	SoundManager sounds = new SoundManager();

	Level level1 = new Level("Level1", 145, sounds);
	Level level2 = new Level("Level2", 145, sounds);
	Level level3 = new Level("Level3", 145, sounds);

	int menu_timer = 0;

	/**
	 * Constructor. See constructor in Game.java for details on the parameters given
	 * */
	public FinalGame() {
		super("Time Shift", 1000, 600);
		Ellipse2D playerHitbox = new Ellipse2D.Double(0, 0, 80, 128);
		Ellipse2D slimeHitbox = new Ellipse2D.Double(0, 0, 100, 100);
		Ellipse2D knightHitbox = new Ellipse2D.Double(0, 0, 80, 116);
		Ellipse2D goblinHitbox = new Ellipse2D.Double(0, 0, 92, 108);
		Ellipse2D fireballHitbox = new Ellipse2D.Double(0, 0, 50, 35);
		Ellipse2D lightningHitbox = new Ellipse2D.Double(0, 0, 50, 50);
		Ellipse2D slimeballHitbox = new Ellipse2D.Double(0, 0, 50, 39);

		player.addHitboxShape(playerHitbox);
		player.setPosition(new Point(60, 400));

		health_pot.setPosition(new Point(10, 60));

		damage_pot.setPosition(new Point(10, 110));

		player_story.setPosition(new Point(140, 200));
		player_story.setScaleX(2);
		player_story.setScaleY(2);

		knight_story.setPosition(new Point(750, 200));
		knight_story.setScaleX(2);
		knight_story.setScaleY(2);

		fairy.setPosition(new Point(750, 200));
		fairy.setScaleX(1.25);
		fairy.setScaleY(1.25);

		black_screen.setPosition(new Point(0, 0));

		knight.addHitboxShape(knightHitbox);
		knight.setPosition(new Point(720, 400));

		goblin.addHitboxShape(goblinHitbox);
		goblin.setPosition(new Point(720, 400));
		goblin.setScaleX(1.5);
		goblin.setScaleY(1.5);

		slime.addHitboxShape(slimeHitbox);
		slime.setPosition(new Point(720, 400));

		fireball.addHitboxShape(fireballHitbox);
		spear.addHitboxShape(fireballHitbox);
		spear_pink.addHitboxShape(fireballHitbox);
		waterball.addHitboxShape(fireballHitbox);
		lightning.addHitboxShape(lightningHitbox);
		big_lightning.addHitboxShape(lightningHitbox);
		big_fireball.addHitboxShape(fireballHitbox);
		enemy_fireball.addHitboxShape(fireballHitbox);
		big_enemy_fireball.addHitboxShape(fireballHitbox);
		slimeball.addHitboxShape(fireballHitbox);

		fireball.setOrigin(new Point(130, 420));
		fireball.setTarget(new Point(720, 400));
		fireball.setPosition(new Point(130, 420));
		fireball.setScaleX(2);
		fireball.setScaleY(2);
		fireball.addLetter('f');
		fireball.setAttack(true);

		waterball.setOrigin(new Point(130, 420));
		waterball.setTarget(new Point(720, 400));
		waterball.setPosition(new Point(130, 420));
		waterball.setScaleX(2);
		waterball.setScaleY(2);
		waterball.addLetter('f');
		waterball.addLetter('o');
		waterball.addLetter('r');
		waterball.setAttack(true);

		lightning.setOrigin(new Point(130, 420));
		lightning.setTarget(new Point(720, 400));
		lightning.setPosition(new Point(130, 420));
		lightning.setScaleX(2);
		lightning.setScaleY(2);
		lightning.addLetter('o');
		lightning.addLetter('f');
		lightning.setAttack(true);

		big_lightning.setOrigin(new Point(130, 420));
		big_lightning.setTarget(new Point(720, 400));
		big_lightning.setPosition(new Point(130, 420));
		big_lightning.setScaleX(2.5);
		big_lightning.setScaleY(2.5);
		big_lightning.addLetter('a');
		big_lightning.addLetter('r');
		big_lightning.addLetter('t');
		big_lightning.setAttack(true);

		big_fireball.setOrigin(new Point(130, 420));
		big_fireball.setTarget(new Point(720, 400));
		big_fireball.setPosition(new Point(130, 420));
		big_fireball.setScaleX(3);
		big_fireball.setScaleY(3);
		big_fireball.addLetter('d');
		big_fireball.setAttack(true);

		slimeball.setOrigin(new Point(690, 400));
		slimeball.setTarget(new Point(60, 400));
		slimeball.setPosition(new Point(690, 400));
		slimeball.setScaleX(2);
		slimeball.setScaleY(2);
		slimeball.addLetter('j');
		slimeball.setAttack(false);

		spear.setOrigin(new Point(690, 400));
		spear.setTarget(new Point(60, 400));
		spear.setPosition(new Point(690, 400));
		spear.setScaleX(2);
		spear.setScaleY(2);
		spear.addLetter('p');
		spear.addLetter('o');
		spear.addLetter('o');
		spear.addLetter('l');
		spear.setAttack(false);

		spear_pink.setOrigin(new Point(690, 400));
		spear_pink.setTarget(new Point(60, 400));
		spear_pink.setPosition(new Point(690, 400));
		spear_pink.setScaleX(2.5);
		spear_pink.setScaleY(2.5);
		spear_pink.addLetter('s');
		spear_pink.addLetter('a');
		spear_pink.addLetter('d');
		spear_pink.setAttack(false);

		enemy_fireball.setOrigin(new Point(690, 400));
		enemy_fireball.setTarget(new Point(60, 400));
		enemy_fireball.setPosition(new Point(690, 400));
		enemy_fireball.setScaleX(2);
		enemy_fireball.setScaleY(2);
		enemy_fireball.addLetter('i');
		enemy_fireball.addLetter('f');
		enemy_fireball.setAttack(false);

		big_enemy_fireball.setOrigin(new Point(690, 400));
		big_enemy_fireball.setTarget(new Point(60, 400));
		big_enemy_fireball.setPosition(new Point(690, 400));
		big_enemy_fireball.setScaleX(3);
		big_enemy_fireball.setScaleY(3);
		big_enemy_fireball.addLetter('j');
		big_enemy_fireball.addLetter('o');
		big_enemy_fireball.addLetter('y');
		big_enemy_fireball.setAttack(false);

		sounds.LoadMusic("theme1", "theme1.wav");
		sounds.LoadMusic("vgvariationtheme", "vgvariationtheme.wav");
		sounds.LoadMusic("vgbattle", "vgbattle.wav");
		sounds.LoadSoundEffect("start", "start.wav");
		sounds.LoadSoundEffect("preL1_0", "preL1_0.wav");
		sounds.LoadSoundEffect("preL1_1", "preL1_1.wav");
		sounds.LoadSoundEffect("preL1_2", "preL1_2.wav");
		sounds.LoadSoundEffect("preL1_3", "preL1_3.wav");
		sounds.LoadSoundEffect("preL1_4", "preL1_4.wav");
		sounds.LoadSoundEffect("preL1_5", "preL1_5.wav");
		sounds.LoadSoundEffect("preL1_6", "preL1_6.wav");
		sounds.LoadSoundEffect("preL1_7", "preL1_7.wav");
		sounds.LoadSoundEffect("preL1_8", "preL1_8.wav");
		sounds.LoadSoundEffect("preL1_9", "preL1_9.wav");
		sounds.LoadSoundEffect("preL1_10", "preL1_10.wav");
		sounds.LoadSoundEffect("preL1_11", "preL1_11.wav");
		sounds.LoadSoundEffect("preL1_12", "preL1_12.wav");
		sounds.LoadSoundEffect("preL1_13", "preL1_13.wav");
		sounds.LoadSoundEffect("preL1_14", "preL1_14.wav");
		sounds.LoadSoundEffect("preL1_15", "preL1_15.wav");
		sounds.LoadSoundEffect("preL1_16_1", "preL1_16_1.wav");
		sounds.LoadSoundEffect("preL1_16_2", "preL1_16_2.wav");
		sounds.LoadSoundEffect("preL1_17", "preL1_17.wav");
		sounds.LoadSoundEffect("preL1_18", "preL1_18.wav");
		sounds.LoadSoundEffect("preL1_19", "preL1_19.wav");
		sounds.LoadSoundEffect("preL1_20", "preL1_20.wav");
		sounds.LoadSoundEffect("preL1_21", "preL1_21.wav");
		sounds.LoadSoundEffect("preL1_22", "preL1_22.wav");
		sounds.LoadSoundEffect("preL1_23", "preL1_23.wav");
		sounds.LoadSoundEffect("preL1_24", "preL1_24.wav");
		sounds.LoadSoundEffect("preL1_25", "preL1_25.wav");
		sounds.LoadSoundEffect("preL1_26", "preL1_26.wav");
		sounds.LoadSoundEffect("preL1_27", "preL1_27.wav");
		sounds.LoadSoundEffect("preL1_28", "preL1_28.wav");
		sounds.LoadSoundEffect("preL1_29", "preL1_29.wav");
		sounds.LoadSoundEffect("postL1_0", "postL1_0.wav");
		sounds.LoadSoundEffect("postL1_1", "postL1_1.wav");
		sounds.LoadSoundEffect("postL1_2", "postL1_2.wav");
		sounds.LoadSoundEffect("postL1_3", "postL1_3.wav");
		sounds.LoadSoundEffect("postL1_4", "postL1_4.wav");
		sounds.LoadSoundEffect("preL2_0", "preL2_0.wav");
		sounds.LoadSoundEffect("preL2_1", "preL2_1.wav");
		sounds.LoadSoundEffect("preL2_2", "preL2_2.wav");
		sounds.LoadSoundEffect("preL2_3", "preL2_3.wav");
		sounds.LoadSoundEffect("preL2_4", "preL2_4.wav");
		sounds.LoadSoundEffect("preL2_5", "preL2_5.wav");
		sounds.LoadSoundEffect("preL2_6", "preL2_6.wav");
		sounds.LoadSoundEffect("postL2_0", "postL2_0.wav");
		sounds.LoadSoundEffect("postL2_1", "postL2_1.wav");
		sounds.LoadSoundEffect("preL3_0", "preL3_0.wav");
		sounds.LoadSoundEffect("preL3_1_village", "preL3_1_village.wav");
		sounds.LoadSoundEffect("preL3_1_lake", "preL3_1_lake.wav");
		sounds.LoadSoundEffect("preL3_2", "preL3_2.wav");
		sounds.LoadSoundEffect("preL3_3", "preL3_3.wav");
		sounds.LoadSoundEffect("preL3_4", "preL3_4.wav");
		sounds.LoadSoundEffect("preL3_5", "preL3_5.wav");
		sounds.LoadSoundEffect("postL3_0", "postL3_0.wav");
		sounds.LoadSoundEffect("postL3_1", "postL3_1.wav");
		sounds.LoadSoundEffect("postL3_2", "postL3_2.wav");
		sounds.LoadSoundEffect("postL3_3", "postL3_3.wav");
		sounds.LoadSoundEffect("postL3_4", "postL3_4.wav");
		sounds.LoadSoundEffect("fireball", "fireball.wav");
		sounds.LoadSoundEffect("slime", "slime.wav");
		sounds.LoadSoundEffect("water", "water.wav");
		sounds.LoadSoundEffect("elec", "elec.wav");
		sounds.LoadSoundEffect("spear", "spear.wav");
		sounds.LoadSoundEffect("p2", "p2.wav");
		sounds.LoadSoundEffect("p10", "p10.wav");
		sounds.LoadSoundEffect("p15", "p15.wav");
		sounds.LoadSoundEffect("p20", "p20.wav");
		sounds.LoadSoundEffect("en5", "en5.wav");
		sounds.LoadSoundEffect("en10", "en10.wav");
		sounds.LoadSoundEffect("en20", "en20.wav");
		sounds.LoadSoundEffect("en25", "en25.wav");
		sounds.LoadSoundEffect("f", "f.wav");
		sounds.LoadSoundEffect("d", "d.wav");
		sounds.LoadSoundEffect("j", "j.wav");
		sounds.LoadSoundEffect("if", "if.wav");
		sounds.LoadSoundEffect("of", "of.wav");
		sounds.LoadSoundEffect("for", "for.wav");
		sounds.LoadSoundEffect("joy", "joy.wav");
		sounds.LoadSoundEffect("art", "art.wav");
		sounds.LoadSoundEffect("sad", "sad.wav");
		sounds.LoadSoundEffect("pool", "pool.wav");
		sounds.LoadSoundEffect("hp10", "hp10.wav");
		sounds.LoadSoundEffect("dc15", "dc15.wav");
		sounds.LoadSoundEffect("block", "tada.wav");
		sounds.PlayMusic("theme1");
	}

	public void startLevel1(){
		player_health = 100;
		enemy_health = 50;
		on_menu = false;

		background_forest.setVisibility(true);
		background_castle.setVisibility(false);
		background_hallway.setVisibility(false);
		menu.setVisibility(false);

		big_fireball.setDamageString("en25");

		preLevel1 = true;
		timer = 0;
		stage = 0;

		player.setVisibility(false);
		slime.setVisibility(false);
		knight.setVisibility(false);
		goblin.setVisibility(false);
		knight_story.setVisibility(false);

		fairy.setVisibility(true);
		player_story.setVisibility(true);
		black_screen.setAlpha(1.0f);
		black_screen.setVisibility(true);
	}

	public void startLevel1Combat(){
		player.setVisibility(true);
		slime.setVisibility(true);
		knight.setVisibility(false);
		goblin.setVisibility(false);

		fairy.setVisibility(false);
		player_story.setVisibility(false);

		ArrayList<TypingSequence> sequences = new ArrayList<TypingSequence>();
		sequences.add(fireball);
		sequences.add(slimeball);
		sequences.add(big_fireball);
		level1.setSequences(sequences);
		ArrayList<Integer> probabilities = new ArrayList<Integer>();
		probabilities.add(45);
		probabilities.add(45);
		probabilities.add(10);
		level1.setProbabilities(probabilities);

		sounds.PlayMusic("vgbattle");
		level1.setActive(true);
	}

	public void startLevel2(){
		on_menu = false;
		player_health = 100;
		enemy_health = 100;

		health_potions = 2;
		damage_potions = 1;

		big_fireball.setDamageString("en5");

		background_forest.setVisibility(false);
		background_castle.setVisibility(false);
		background_hallway.setVisibility(true);

		preLevel2 = true;
		timer = 0;
		stage = 0;

		player.setVisibility(false);
		slime.setVisibility(false);
		knight.setVisibility(false);
		goblin.setVisibility(false);
		fairy.setVisibility(false);

		knight_story.setVisibility(true);
		player_story.setVisibility(true);
		menu.setVisibility(false);
		sounds.PlayMusic("vgvariationtheme");
	}

	public void startLevel2Combat(){

		player.setVisibility(true);
		knight.setVisibility(true);
		slime.setVisibility(false);
		goblin.setVisibility(false);
		knight_story.setVisibility(false);
		player_story.setVisibility(false);

		ArrayList<TypingSequence> sequences = new ArrayList<TypingSequence>();
		sequences.add(big_fireball);
		sequences.add(enemy_fireball);
		sequences.add(big_enemy_fireball);
		sequences.add(waterball);
		sequences.add(lightning);
		level2.setSequences(sequences);
		ArrayList<Integer> probabilities = new ArrayList<Integer>();
		probabilities.add(4);
		probabilities.add(24);
		probabilities.add(24);
		probabilities.add(24);
		probabilities.add(24);
		level2.setProbabilities(probabilities);

		level2.setActive(true);
		sounds.PlayMusic("vgbattle");
	}

	public void startLevel3(){
		on_menu = false;
		player_health = 100;
		enemy_health = 100;

		background_forest.setVisibility(false);
		background_castle.setVisibility(true);
		background_hallway.setVisibility(false);

		preLevel3 = true;
		timer = 0;
		stage = 0;

		player.setVisibility(false);
		slime.setVisibility(false);
		knight.setVisibility(false);
		goblin.setVisibility(false);
		knight_story.setVisibility(false);

		player_story.setVisibility(true);
		fairy.setVisibility(true);
		menu.setVisibility(false);
		sounds.PlayMusic("vgvariationtheme");
	}

	public void startLevel3Combat(){
		player.setVisibility(true);
		knight.setVisibility(false);
		slime.setVisibility(false);
		goblin.setVisibility(true);

		player_story.setVisibility(false);
		fairy.setVisibility(false);

		ArrayList<TypingSequence> sequences = new ArrayList<TypingSequence>();
		sequences.add(waterball);
		sequences.add(lightning);
		sequences.add(big_lightning);
		sequences.add(spear);
		sequences.add(spear_pink);
		level3.setSequences(sequences);
		ArrayList<Integer> probabilities = new ArrayList<Integer>();
		probabilities.add(15);
		probabilities.add(15);
		probabilities.add(20);
		probabilities.add(25);
		probabilities.add(25);
		level3.setProbabilities(probabilities);
		sounds.PlayMusic("vgbattle");

		level3.setActive(true);
	}

	/**
	 * Engine will automatically call this update method once per frame and pass to us
	 * the set of keys (as strings) that are currently being pressed down
	 * */
	@Override
	public void update(ArrayList<Integer> pressedKeys) {
		super.update(pressedKeys);

		if(on_menu){
			menu_timer += 1;
			if(menu_timer > 250)  {
				sounds.PlaySoundEffect("start");
				menu_timer = 0;
			}
		}

		if(pressedKeys.contains(KeyEvent.VK_ESCAPE)){
			on_menu = true;
			sounds.PlayMusic("theme1");
			menu_timer = 0;
			menu.setVisibility(true);
			level1.setActive(false);
			level2.setActive(false);
			level3.setActive(false);
			preLevel1 = false;
			preLevel2 = false;
			preLevel3 = false;
			postLevel1 = false;
			postLevel2 = false;
			postLevel3 = false;
		}

		if(preLevel1 || preLevel2 || preLevel3 || postLevel1 || postLevel2 || postLevel3){
			if(pressedKeys.contains(KeyEvent.VK_SPACE) && !decision){
				key_space_pressed = true;
			} else if(key_space_pressed && !decision){
				timer = 0;
				stage += 1;
				key_space_pressed = false;
			}
		}

		if(preLevel1){
			timer += 1;
			if(stage >= 30){
				preLevel1 = false;
				sounds.StopSoundEffect();
				startLevel1Combat();
			}
			decision = false;
			if(stage != 0){
				black_screen.setVisibility(false);
			}
			if(stage == 0 && timer < 300){
				if(timer == 3)  {sounds.PlaySoundEffect("preL1_0");}
				player_story.setAlpha(1.0f);
				fairy.setAlpha(0.55f);
				text = "Where am I? This doesn't feel like my bed!";
				text2 = "";
				if(timer < 200){
					black_screen.setAlpha((float) (1.0 - ((double)timer / 200.0)));
				} else {
					black_screen.setVisibility(false);
				}
			} else if(stage == 1 && timer < 300){
				if(timer == 3)  {sounds.PlaySoundEffect("preL1_1");}
				fairy.setAlpha(1.0f);
				player_story.setAlpha(0.55f);
				text = "Hey! You look like you had a rough night.";
				text2 = "I'm a fairy. I'm here to help you out.";
			} else if(stage == 2 && timer < 200){
				if(timer == 3)  {sounds.PlaySoundEffect("preL1_2");}
				player_story.setAlpha(1.0f);
				fairy.setAlpha(0.55f);
				text = "What's going on?";
				text2 = "";
			} else if(stage == 3 && timer < 300){
				if(timer == 3)  {sounds.PlaySoundEffect("preL1_3");}
				fairy.setAlpha(1.0f);
				player_story.setAlpha(0.7f);
				text = "Oh no! I'll fill you in on everything later.";
				text2 = "There's a slime approaching!";
			} else if(stage == 4 && timer < 300){
				if(timer == 3)  {sounds.PlaySoundEffect("preL1_4");}
				text = "Slimes are not friendly. You'll need";
				text2 = "to defend yourself.";
			} else if(stage == 5 && timer < 300){
				if(timer == 3)  {sounds.PlaySoundEffect("preL1_5");}
				text = "Hey, you have these things called keyboards";
				text2 = "in your world right?";
			} else if(stage == 6 && timer < 200){
				if(timer == 3)  {sounds.PlaySoundEffect("preL1_6");}
				player_story.setAlpha(1.0f);
				fairy.setAlpha(0.55f);
				text = "Um, yeah, but I don't know how to use one...";
				text2 = "";
			} else if(stage == 7 && timer < 300){
				if(timer == 3)  {sounds.PlaySoundEffect("preL1_7");}
				fairy.setAlpha(1.0f);
				player_story.setAlpha(0.7f);
				text = "Well now's your chance to learn!";
			} else if(stage == 8 && timer < 300){
				if(timer == 3)  {sounds.PlaySoundEffect("preL1_8");}
				text = "I have a magical one you can use to";
				text2 = "cast spells!";
			} else if(stage == 9 && timer < 300){
				if(timer == 3)  {sounds.PlaySoundEffect("preL1_9");}
				text = "Can you see the keys on the keyboard?";
				text2 = "";
			} else if(stage == 10 && timer < 0){
			} else if(stage == 11 && timer < 200){
				if(timer == 3)  {sounds.PlaySoundEffect("preL1_11");}
				player_story.setAlpha(1.0f);
				fairy.setAlpha(0.55f);
				text = "I can't see the keyboard that well.";
			} else if(stage == 12 && timer < 200){
				if(timer == 3)  {sounds.PlaySoundEffect("preL1_12");}
				fairy.setAlpha(1.0f);
				player_story.setAlpha(0.55f);
				text = "That's okay! I\'ll help you out.";
				text2 = "Just listen to me and do what I say!";
			} else if(stage == 13 && timer < 300){
				if(timer == 3)  {sounds.PlaySoundEffect("preL1_13");}
				text = "Can you feel the two keys which have bumps";
				text2 = "on them? They're in the middle.";
			} else if(stage == 14){
				if(timer == 3)  {sounds.PlaySoundEffect("preL1_14");}
				text = "Press one of the bumpy keys.";
				text2 = "";
				decision = true;
				if(pressedKeys.contains(KeyEvent.VK_F) || pressedKeys.contains(KeyEvent.VK_J)){
					stage += 1;
					timer = 0;
				}
			} else if(stage == 15 && timer < 200){
				if(timer == 3)  {sounds.PlaySoundEffect("preL1_15");}
				text = "Good job!";
			} else if(stage == 16 && timer < 300){
				if(timer == 3)  {sounds.PlaySoundEffect("preL1_16_1");}
				if(timer == 150)  {sounds.PlaySoundEffect("preL1_16_2");}
				text = "The bumpy key on the left is F";
				text2 = "and the bumpy key on right is J";
			} else if(stage == 17){
				if(timer == 3)  {sounds.PlaySoundEffect("preL1_17");}
				text = "Try pressing F with your left index finger";
				text2 = "";
				decision = true;
				if(pressedKeys.contains(KeyEvent.VK_F)){
					stage += 1;
					timer = 0;
				}
			} else if(stage == 18){
				if(timer == 3)  {sounds.PlaySoundEffect("preL1_18");}
				text = "Great! Now try pressing J with your";
				text2 = "right index finger";
				decision = true;
				if(pressedKeys.contains(KeyEvent.VK_J)){
					stage += 1;
					timer = 0;
				}
			} else if(stage == 19){
				text = "Now press both F and J";
				text2 = "";
				decision = true;
				if(pressedKeys.contains(KeyEvent.VK_J) && pressedKeys.contains(KeyEvent.VK_F)){
					stage += 1;
					timer = 0;
				}
			} else if(stage == 20 && timer < 350){
				if(timer == 3)  {sounds.PlaySoundEffect("preL1_20");}
				if(timer == 220)  {sounds.PlaySoundEffect("fireball");}
				text = "When you press F, you\'ll throw a fireball";
				text2 = "and hear this sound: [Fireball sound]";
			}else if(stage == 21 && timer < 350){
				if(timer == 3)  {sounds.PlaySoundEffect("preL1_21");}
				if(timer == 230)  {sounds.PlaySoundEffect("slime");}
				text = "When you press J, you\'ll deflect a slime";
				text2 = "attack and hear this sound: [Slimeball sound]";
			} else if(stage == 22 && timer < 400){
				if(timer == 3)  {sounds.PlaySoundEffect("preL1_22");}
				text = "I\'ll tell you right before you need to press";
				text2 = "F or J. You\'ll have to press the key quickly.";
			} else if(stage == 23 && timer < 400){
				if(timer == 3)  {sounds.PlaySoundEffect("preL1_23");}
				text = "One last thing. You can press D to throw";
				text2 = "a larger fireball. Here's how to find D:";
			} else if(stage == 24 && timer < 400){
				if(timer == 3)  {sounds.PlaySoundEffect("preL1_24");}
				text = "Slide your left index finger over from F";
				text2 = "one key to the left. This is D.";
			} else if(stage == 25 && timer < 400){
				if(timer == 3)  {sounds.PlaySoundEffect("preL1_25");}
				text = "After you press D, slide your left index";
				text2 = "finger back to the right to the F key,";
			} else if(stage == 26){
				if(timer == 3)  {sounds.PlaySoundEffect("preL1_26");}
				text = "and put your left middle finger on D.";
				text2 = "Now press D with your middle finger.";
				decision = true;
				if(pressedKeys.contains(KeyEvent.VK_D)){
					d_key_pressed = true;
				} else if(d_key_pressed == true){
					stage += 1;
					timer = 0;
					d_key_pressed = false;
				}
			} else if(stage == 27){
				if(timer == 3)  {sounds.PlaySoundEffect("preL1_27");}
				text = "Good. Press D again";
				text2 = "";
				decision = true;
				if(pressedKeys.contains(KeyEvent.VK_D)){
					d_key_pressed = true;
				} else if(d_key_pressed == true){
					stage += 1;
					timer = 0;
					d_key_pressed = false;
				}
			} else if(stage == 28){
				if(timer == 3)  {sounds.PlaySoundEffect("preL1_28");}
				text = "Are you good to go? Press F if you are ready.";
				text2 = "Press J if you want me to repeat myself.";
				decision = true;
				if(pressedKeys.contains(KeyEvent.VK_J)){
					stage = 12;
					timer = 0;
					text2 = "";
				}
				if(pressedKeys.contains(KeyEvent.VK_F)){
					stage += 1;
					timer = 0;
				}
			} else if(stage == 29 && timer < 250){
				if(timer == 3)  {sounds.PlaySoundEffect("preL1_29");}
				text =  "You\'ve got this!";
				text2 = "";
			} else {
				stage += 1;
				timer = 0;
			}
		}
		if(postLevel1){
			timer += 1;
			if(stage >= 5){
				postLevel1 = false;
				startLevel2();
			}
			decision = false;
			if(stage == 0 && timer < 300){
				player_story.setAlpha(1.0f);
				fairy.setAlpha(0.55f);
				if(timer == 3)  {sounds.PlaySoundEffect("postL1_0");}
				text = "That was some sort of monster!";
				text2 = "I need to get back home.";
			} else if(stage == 1 && timer < 300){
				fairy.setAlpha(1.0f);
				player_story.setAlpha(0.55f);
				if(timer == 3)  {sounds.PlaySoundEffect("postL1_1");}
				text = "I'll help you. But let\'s get out";
				text2 = "of here first.";
			} else if(stage == 2 && timer < 300){
				if(timer == 3)  {sounds.PlaySoundEffect("postL1_2");}
				text = "Do you want to head to the lake";
				text2 = "or the village?";
			} else if(stage == 3){
				if(timer == 3)  {sounds.PlaySoundEffect("postL1_3");}
				text = "[Press F to go to the lake. Press";
				text2 = "J to go to the village]";
				decision = true;
				if(pressedKeys.contains(KeyEvent.VK_F)){
					stage += 1;
					timer = 0;
					village = false;
				}else if(pressedKeys.contains(KeyEvent.VK_J)){
					stage += 1;
					timer = 0;
					village = true;
				}
			} else if(stage == 4 && timer < 200){
				if(timer == 3)  {sounds.PlaySoundEffect("postL1_4");}
				text = "Let\'s go.";
				text2 = "";
				if(timer == 145)  {sounds.PlaySoundEffect("block");}
			} else {
				stage += 1;
				timer = 0;
			}
		}
		if(preLevel2){
			timer += 1;
			if(stage >= 7){
				preLevel2 = false;
				sounds.StopSoundEffect();
				startLevel2Combat();
			}
			decision = false;
			if(stage == 0 && timer < 300){
				if(timer == 16)  {sounds.PlaySoundEffect("preL2_0");}
				player_story.setAlpha(0.55f);
				knight_story.setAlpha(1.0f);
				text = "I\'m here to help teach you more";
				text2 = "advanced fighting skills.";
			} else if(stage == 1 && timer < 300){
				if(timer == 3)  {sounds.PlaySoundEffect("preL2_1");}
				text = "I\'ve heard that you know how to";
				text2 = "use all the keys on your keyboard.";
			} else if(stage == 2 && timer < 300){
				if(timer == 3)  {sounds.PlaySoundEffect("preL2_2");}
				text = "Now you\'re practicing moves where you";
				text2 = "press several keys in a row.";
			} else if(stage == 3 && timer < 300){
				if(timer == 3)  {sounds.PlaySoundEffect("preL2_3");}
				text = "Let\'s fight a training match.";
				text2 = "Remember what you\'ve learned so far.";
			} else if(stage == 4 && timer < 300){
				if(timer == 3)  {sounds.PlaySoundEffect("preL2_4");}
				text = "Also, remember that your inventory has";
				text2 = "two healing potions and a damage charm.";
			} else if(stage == 5 && timer < 300){
				if(timer == 3)  {sounds.PlaySoundEffect("preL2_5");}
				text = "Press 1 to use a healing potion and";
				text2 = "press 2 to use the damage charm.";
			} else if(stage == 6 && timer < 200){
				if(timer == 3)  {sounds.PlaySoundEffect("preL2_6");}
				text = "Here we go.";
				text2 = "";
			} else {
				stage += 1;
				timer = 0;
			}
		}
		if(postLevel2){
			timer += 1;
			if(stage >= 2){
				postLevel2 = false;
				startLevel3();
			}
			decision = false;
			if(stage == 0 && timer < 300){
				if(timer == 3)  {sounds.PlaySoundEffect("postL2_0");}
				text = "Looks like you\'re ready to head out";
				text2 = "and fight the goblin.";
				player_story.setAlpha(0.55f);
				knight_story.setAlpha(1.0f);
			} else if(stage == 1 && timer < 300){
				if(timer == 3)  {sounds.PlaySoundEffect("postL2_1");}
				if(timer == 245)  {sounds.PlaySoundEffect("block");}
				if(timer == 5){
					health_potions += 1;
				}
				text = "Take an extra healing potion before";
				text2 = "you go!";
			} else {
				stage += 1;
				timer = 0;
			}
		}
		if(preLevel3){
			timer += 1;
			if(stage >= 6){
				preLevel3 = false;
				sounds.StopSoundEffect();
				startLevel3Combat();
			}
			decision = false;
			if(stage == 0 && timer < 250){
				if(timer == 3)  {sounds.PlaySoundEffect("preL3_0");}
				player_story.setAlpha(0.55f);
				fairy.setAlpha(1.0f);
				text = "The goblin should be around here.";
				text2 = "";
			} else if(stage == 1 && timer < 300){
				if(village){
					if(timer == 3)  {sounds.PlaySoundEffect("preL3_1_village");}
					text = "Here\'s the damage charm we got in";
					text2 = "the village. You might need it.";
					if(timer == 5){
						damage_potions += 1;
					}
				} else {
					if(timer == 3)  {sounds.PlaySoundEffect("preL3_1_lake");}
					text = "Here\'s the healing potion we found";
					text2 = "by the lake. You might need it.";
					if(timer == 5){
						health_potions += 1;
					}
				}
			} else if(stage == 2 && timer < 300){
				if(timer == 3)  {sounds.PlaySoundEffect("preL3_2");}
				text = "I\'m going to charge your keyboard with";
				text2 = "some more attacks and defenses.";
			} else if(stage == 3 && timer < 300){
				if(timer == 3)  {sounds.PlaySoundEffect("preL3_3");}
				text = "These moves might be a bit harder than";
				text2 = "the spells you\'ve learned so far.";
			} else if(stage == 4 && timer < 300){
				if(timer == 3)  {sounds.PlaySoundEffect("preL3_4");}
				text = "Oh no! The goblin\'s coming. I don\'t";
				text2 = "have time to train you with the new moves.";
			} else if(stage == 5 && timer < 300){
				if(timer == 3)  {sounds.PlaySoundEffect("preL3_5");}
				text = "Just press the keys when I tell you -";
				text2 = "like we've been practicing.";
			} else {
				stage += 1;
				timer = 0;
			}
		}
		if(postLevel3){
			timer += 1;
			if(stage >= 5){
				postLevel3 = false;
				menu.setVisibility(true);
				on_menu = true;
				sounds.PlayMusic("theme1");
				menu_timer = 0;
			}
			decision = false;
			if(stage == 0 && timer < 200){
				if(timer == 3)  {sounds.PlaySoundEffect("postL3_0");}
				text = "Good job! You beat the goblin.";
				text2 = "";
				player_story.setAlpha(0.55f);
				fairy.setAlpha(1.0f);
			} else if(stage == 1 && timer < 300){
				if(timer == 3)  {sounds.PlaySoundEffect("postL3_1");}
				text = "My fairy senses tell me that there\'s";
				text2 = "danger nearby.";
			} else if(stage == 2 && timer < 350){
				if(timer == 3)  {sounds.PlaySoundEffect("postL3_2");}
				text = "Should we look into the danger or head";
				text2 = "straight back to the castle?";
			} else if(stage == 3){
				if(timer == 3)  {sounds.PlaySoundEffect("postL3_3");}
				text = "[Press F to head towards the danger. Press";
				text2 = "J to back to the castle]";
				decision = true;
				if(pressedKeys.contains(KeyEvent.VK_F) || pressedKeys.contains(KeyEvent.VK_J)){
					stage += 1;
					timer = 0;
				}
			} else if(stage == 4 && timer < 200){
				if(timer == 3)  {sounds.PlaySoundEffect("postL3_4");}
				text = "Let\'s go.";
				text2 = "";
			} else {
				stage += 1;
				timer = 0;
			}
		}

		if(fireball != null && slime != null && player != null && slimeball != null && level1 != null
				&& level2 != null && level3 != null && big_fireball != null && enemy_fireball != null
				&& knight !=  null && waterball != null && big_enemy_fireball != null && lightning != null){
			if(on_menu){
				if(pressedKeys.size() > 0){
					if(pressedKeys.contains(KeyEvent.VK_SPACE)){
						key_space_pressed = true;
					} else {
						key_pressed = true;
					}
				} else {
					if(key_space_pressed) {
						key_space_pressed = false;
						if(starting_level == 1){
							startLevel1();
						}
						if(starting_level == 2){
							black_screen.setVisibility(false);
							startLevel2();
						}
						if(starting_level == 3){
							black_screen.setVisibility(false);
							health_potions = 2;
							damage_potions = 1;
							startLevel3();
						}
					}
					if(key_pressed){
						key_pressed = false;
						starting_level += 1;
						if(starting_level > 3){
							starting_level = 1;
						}
					}
				}
			}
			if(level1.getActive()){
				level1.updateTime(pressedKeys);
			}
			if(level2.getActive()){
				if(pressedKeys.contains(KeyEvent.VK_1) && potion_timer == 0  && health_potions > 0){
					potion_timer = 1;
					health_potions -= 1;
					player_health += 10;
					sounds.PlaySoundEffect("hp10");
					if(player_health > 100){
						player_health = 100;
					}
				}
				if(pressedKeys.contains(KeyEvent.VK_2) && potion_timer == 0 && damage_potions > 0){
					potion_timer = 1;
					damage_potions -= 1;
					sounds.PlaySoundEffect("dc15");
					enemy_health -= 15;
				}
				if(potion_timer > 0){
					potion_timer += 1;
					if(potion_timer > 200){
						potion_timer = 0;
					}
				} else {
					level2.updateTime(pressedKeys);
				}
			}
			if(level3.getActive()){
				if(pressedKeys.contains(KeyEvent.VK_1) && potion_timer == 0 && health_potions > 0){
					potion_timer = 1;
					health_potions -= 1;
					player_health += 10;
					sounds.PlaySoundEffect("hp10");
					if(player_health > 100){
						player_health = 100;
					}
				}
				if(pressedKeys.contains(KeyEvent.VK_2) && potion_timer == 0 && damage_potions > 0){
					potion_timer = 1;
					damage_potions -= 1;
					sounds.PlaySoundEffect("dc15");
					enemy_health -= 15;
				}
				if(potion_timer > 0){
					potion_timer += 1;
					if(potion_timer > 200){
						potion_timer = 0;
					}
				} else {
					level3.updateTime(pressedKeys);
				}
			}
			if(slime.collidesWith(fireball) && fireball.getActive() && level1.getActive()){
				enemy_health -= 10;
				fireball.setActive(false);
			}
			if(slime.collidesWith(big_fireball) && big_fireball.getActive() && level1.getActive()){
				enemy_health -= 25;
				big_fireball.setActive(false);
			}
			if(knight.collidesWith(big_fireball) && big_fireball.getActive() && level2.getActive()){
				enemy_health -= 5;
				big_fireball.setActive(false);
			}
			if(knight.collidesWith(waterball) && waterball.getActive() && level2.getActive()){
				enemy_health -= 10;
				waterball.setActive(false);
			}
			if(knight.collidesWith(lightning) && lightning.getActive() && level2.getActive()){
				enemy_health -= 10;
				lightning.setActive(false);
			}
			if(goblin.collidesWith(waterball) && waterball.getActive() && level3.getActive()){
				enemy_health -= 10;
				waterball.setActive(false);
			}
			if(goblin.collidesWith(lightning) && lightning.getActive() && level3.getActive()){
				enemy_health -= 10;
				lightning.setActive(false);
			}
			if(goblin.collidesWith(big_lightning) && big_lightning.getActive() && level3.getActive()){
				enemy_health -= 20;
				big_lightning.setActive(false);
			}
			if(player.collidesWith(slimeball) && slimeball.getActive()){
				player_health -= 2;
				slimeball.setActive(false);
			}
			if(player.collidesWith(enemy_fireball) && enemy_fireball.getActive()){
				player_health -= 10;
				enemy_fireball.setActive(false);
			}
			if(player.collidesWith(spear) && spear.getActive()){
				player_health -= 15;
				spear.setActive(false);
			}
			if(player.collidesWith(spear_pink) && spear_pink.getActive()){
				player_health -= 10;
				spear_pink.setActive(false);
			}
			if(player.collidesWith(big_enemy_fireball) && big_enemy_fireball.getActive()){
				player_health -= 20;
				big_enemy_fireball.setActive(false);
			}
			if(level1.getActive() && enemy_health <= 0){
				level1.setActive(false);
				sounds.PlayMusic("theme1");
				player.setVisibility(false);
				slime.setVisibility(false);
				player_story.setVisibility(true);
				fairy.setVisibility(true);
				postLevel1 = true;
				timer = 0;
				stage = 0;
			}
			if(level2.getActive() && enemy_health <= 0){
				level2.setActive(false);
				sounds.PlayMusic("vgvariationtheme");
				player.setVisibility(false);
				knight.setVisibility(false);
				player_story.setVisibility(true);
				knight_story.setVisibility(true);
				postLevel2 = true;
				timer = 0;
				stage = 0;
			}
			if(level3.getActive() && enemy_health <= 0){
				level3.setActive(false);
				sounds.PlayMusic("vgvariationtheme");
				player.setVisibility(false);
				goblin.setVisibility(false);
				player_story.setVisibility(true);
				fairy.setVisibility(true);
				postLevel3 = true;
				timer = 0;
				stage = 0;
			}
			if(player_health < 0 && (level1.getActive() || level2.getActive() || level3.getActive())){
				level1.setActive(false);
				level2.setActive(false);
				level3.setActive(false);
				on_menu = true;
				sounds.PlayMusic("theme1");
				menu_timer = 0;
				menu.setVisibility(true);
			}
		}
	}
	
	/**
	 * Engine automatically invokes draw() every frame as well. If we want to make sure mario gets drawn to
	 * the screen, we need to make sure to override this method and call mario's draw method.
	 * */
	@Override
	public void draw(Graphics g){
		super.draw(g);
		
		/* Same, just check for null in case a frame gets thrown in before Mario is initialized */
		if(background_castle != null) background_castle.draw(g);
		if(background_hallway != null) background_hallway.draw(g);
		if(background_forest != null) background_forest.draw(g);
		if(player != null) player.draw(g);
		if(slime != null) slime.draw(g);
		if(knight != null) knight.draw(g);
		if(goblin != null) goblin.draw(g);
		if(fireball != null) fireball.draw(g);
		if(waterball != null) waterball.draw(g);
		if(lightning != null) lightning.draw(g);
		if(big_lightning != null) big_lightning.draw(g);
		if(spear != null) spear.draw(g);
		if(spear_pink != null) spear_pink.draw(g);
		if(big_fireball != null) big_fireball.draw(g);
		if(enemy_fireball != null) enemy_fireball.draw(g);
		if(big_enemy_fireball != null) big_enemy_fireball.draw(g);
		if(slimeball != null) slimeball.draw(g);
		if(fairy != null) fairy.draw(g);
		if(player_story != null) player_story.draw(g);
		if(knight_story != null) knight_story.draw(g);
		if(black_screen != null) black_screen.draw(g);

		if(menu != null) menu.draw(g);

		if(level1 != null && level2 != null && level3 != null){
			if(!level1.getActive() && !preLevel1 && !postLevel1 && !on_menu){
				if(health_pot != null) health_pot.draw(g);
				if(damage_pot != null) damage_pot.draw(g);
				g.setFont(new Font("Arial", Font.BOLD, 60));
				g.setColor(Color.black);
				g.drawString(String.valueOf(health_potions), 80, 100);
				g.drawString(String.valueOf(damage_potions), 80, 150);
			}
			String letters = "";
			if(level1.getActive()){
				letters = level1.getCurrentSequence().getLetters().toString();
			} else if(level2.getActive()){
				if(level2.getCurrentSequence() != null){
					letters = level2.getCurrentSequence().getLetters().toString();
				}
			} else if(level3.getActive()){
				if(level3.getCurrentSequence() != null){
					letters = level3.getCurrentSequence().getLetters().toString();
				}
			}
			if(!letters.equals("")){
				g.setColor(Color.white);
				g.fillRect(280, 20, 480, 100);
				g.setFont(new Font("Arial", Font.BOLD, 60));
				g.setColor(Color.black);
				g.drawString("Type: " + letters, 300, 80);
				g.setColor(Color.green);
				g.fillRect(10, 10, player_health, 40);
				g.setColor(Color.blue);
				g.fillRect(990 - enemy_health, 10, enemy_health, 40);
			} else if(on_menu) {
				g.setFont(new Font("Arial", Font.BOLD, 60));
				g.setColor(Color.black);
				g.drawString("Press space for level " + starting_level, 140, 80);
			}
		}
		if (preLevel1 || preLevel2 || preLevel3 || postLevel1 || postLevel2 || postLevel3){
			g.setColor(Color.darkGray);
			g.fillRect(0, 400, 1000, 200);
			g.setFont(new Font("Arial", Font.BOLD, 45));
			g.setColor(Color.white);
			g.drawString(text, 25, 460);
			g.drawString(text2, 25, 510);
		}
	}

	/**
	 * Quick main class that simply creates an instance of our game and starts the timer
	 * that calls update() and draw() every frame
	 * */
	public static void main(String[] args) {
		FinalGame game = new FinalGame();
		game.start();

	}
}
