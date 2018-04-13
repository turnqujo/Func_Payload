namespace FuncPayload
{
  enum eSoundState
  {
    PLAYING,
    STOPPED
  };

  const string DEFAULT_MOVE_SOUND = "plats/talkmove2.wav";
  const string DEFAULT_STOP_SOUND = "plats/talkstop1.wav";
  const int INITIAL_PITCH = 60;
  const int MAX_PITCH = 200;
  const int APPROX_MAX_SPEED = 1000;

  /**
   * Sound Manager
   *  Responsible for caching, playing, stopping, and other operations involving sound.
   */
  mixin class MXCSoundManager
  {
    eSoundState currentSoundState = STOPPED;

    void PrecacheSounds()
    {
      if (m_flVolume == 0.0)
        m_flVolume = 1.0;

      if (m_sounds <= 0)
      {
        pev.noise = "";
        return;
      }

      pev.noise = DEFAULT_MOVE_SOUND;
      g_SoundSystem.PrecacheSound(pev.noise);
      g_SoundSystem.PrecacheSound(DEFAULT_STOP_SOUND);
    }

    void StopSound()
    {
      if (NoSound() || currentSoundState == STOPPED)
        return;

      g_SoundSystem.StopSound(self.edict(), CHAN_STATIC, pev.noise);
      g_SoundSystem.EmitSoundDyn(self.edict(), CHAN_STATIC, DEFAULT_STOP_SOUND, m_flVolume, ATTN_NORM, 0, GetAdjustedPitch());
      currentSoundState = STOPPED;
    }

    void PlaySound()
    {
      if (NoSound() || currentSoundState == PLAYING)
        return;

      g_SoundSystem.EmitSoundDyn(self.edict(), CHAN_STATIC, pev.noise, m_flVolume, ATTN_NORM, SND_CHANGE_PITCH, GetAdjustedPitch());
      currentSoundState = PLAYING;
    }

    private bool NoSound()
    {
      return string(pev.noise).IsEmpty();
    }

    // NOTE: This method depends on the Movement Manager
    private int GetAdjustedPitch()
    {
      return int(INITIAL_PITCH + (abs(int(GetCurrentAdjustedSpeed())) * (MAX_PITCH - INITIAL_PITCH) / APPROX_MAX_SPEED));
    }
  }
}
