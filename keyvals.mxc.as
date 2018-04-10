namespace FuncPayload
{
  mixin class mxCFuncPayloadKeyVals
  {
    float m_iDetectionRadius = 0;
    Vector m_vFriendlyGlowColor = parseVector("205, 10, 10");
    Vector m_vEnemyGlowColor = parseVector("205, 10, 10");
    float m_flHeight;
    float m_flLength; // Wheels
    float m_flStartSpeed;
    float m_flBank;
    bool m_bShouldFriendliesGlow = true;
    bool m_bShouldEnemiesGlow = true;
    float m_flSpeedMultiplier = 1.0;
    uint m_uiSpeedMultiplierMax = 3;
    int m_sounds;
    float m_flVolume;
    float m_flMaxSpeed;

    bool KeyValue(const string & in szKey, const string & in szValue)
    {
      if (szKey == "iDetectionRadius")
      {
        m_iDetectionRadius = Math.max(atoi(szValue), 0);
        return true;
      }

      if (szKey == "friendlyGlowColor")
      {
        m_vFriendlyGlowColor = parseVector(szValue);
        return true;
      }

      if (szKey == "enemyGlowColor")
      {
        m_vEnemyGlowColor = parseVector(szValue);
        return true;
      }

      if (szKey == "height")
      {
        m_flHeight = atof(szValue);
        return true;
      }

      if (szKey == "wheels")
      {
        m_flLength = atof(szValue);
        return true;
      }

      if (szKey == "startspeed")
      {
        m_flStartSpeed = atof(szValue);
        return true;
      }

      if (szKey == "bank")
      {
        m_flBank = atof(szValue);
        return true;
      }

      if (szKey == "bShouldFriendliesGlow")
      {
        m_bShouldFriendliesGlow = szValue == 0 ? false : true;
        return true;
      }

      if (szKey == "bShouldEnemiesGlow")
      {
        m_bShouldEnemiesGlow = szValue == 0 ? false : true;
        return true;
      }

      if (szKey == "flSpeedMultiplier")
      {
        m_flSpeedMultiplier = atof(szValue);
        return true;
      }

      if (szKey == "uiSpeedMultiplierMax")
      {
        m_uiSpeedMultiplierMax = atoi(szValue);
        return true;
      }

      if (szKey == 'sounds')
      {
        m_sounds = atoi(szValue);
        return true;
      }

      if (szKey == "volume")
      {
        m_flVolume = float(atoi(szValue));
        m_flVolume *= 0.1;
        return true;
      }

      if (szKey == "flMaxSpeed")
      {
        m_flMaxSpeed = atof(szValue);
        return true;
      }

      return BaseClass.KeyValue(szKey, szValue);
    }

    // (borrowed from env_weather) convert output from Vector.ToString() back into a Vector
    Vector parseVector(string s) {
    	array<string> values = s.Split(" ");
    	Vector v(0, 0, 0);
    	if (values.length() > 0) v.x = atof(values[0]);
    	if (values.length() > 1) v.y = atof(values[1]);
    	if (values.length() > 2) v.z = atof(values[2]);
    	return v;
    }
  }
}
