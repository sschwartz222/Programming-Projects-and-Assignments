package edu.virginia.engine.display;

import java.util.*;
import java.io.*;
import javax.sound.sampled.*;

public class SoundManager {

    private HashMap sfx;

    private HashMap music;

    private Clip musicClip;

    private Clip sfxClip;

    public SoundManager() {
        this.sfx = new HashMap();
        this.music = new HashMap();
    }

    public void LoadSoundEffect(String id, String filename) {
        sfx.put(id, "resources" + File.separator + filename);
    }

    public void StopSoundEffect() {
        if(sfxClip != null){ sfxClip.stop(); }
    }

    public void PlaySoundEffect(String id) {
        if(sfxClip != null){ sfxClip.stop(); }
        try {
            System.out.println((String) sfx.get(id));
            File sfxFile = new File((String) sfx.get(id));
            AudioInputStream audioInputStream = AudioSystem.getAudioInputStream(sfxFile);
            sfxClip = AudioSystem.getClip();
            sfxClip.open(audioInputStream);
        } catch (UnsupportedAudioFileException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } catch (LineUnavailableException e) {
            e.printStackTrace();
        }
        if (sfxClip.isRunning())
            sfxClip.stop();
        sfxClip.setFramePosition(0);
        sfxClip.start();
    }

    public void LoadMusic(String id, String filename) {
        music.put(id, "resources" + File.separator + filename);
    }

    public void PlayMusic(String id) {
        Set set = music.entrySet();

        if(musicClip != null){ musicClip.stop(); }

        // Get an iterator
        Iterator i = set.iterator();

        // Display elements
        while(i.hasNext()) {
            Map.Entry me = (Map.Entry)i.next();
        }
        try {
            File musicFile = new File((String) music.get(id));
            AudioInputStream audioInputStream = AudioSystem.getAudioInputStream(musicFile);
            musicClip = AudioSystem.getClip();
            musicClip.open(audioInputStream);
        } catch (UnsupportedAudioFileException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } catch (LineUnavailableException e) {
            e.printStackTrace();
        }
        if (musicClip.isRunning())
            musicClip.stop();
        musicClip.setFramePosition(0);
        musicClip.loop(Clip.LOOP_CONTINUOUSLY);
    }
}

