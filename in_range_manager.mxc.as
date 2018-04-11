namespace FuncPayload
{

  /**
   * In-Range Manager
   *
   * Responsible for keeping track of friendly and enemy entities in range
   *  of the payload, as well as performing actions on them (e.g. healing).
   */
  mixin class mxCInRangeManager
  {
    array<CBaseMonster@> entsInRange = array<CBaseMonster@>();
    string iHasBeenTouchedKey = "$i_hasBeenTouched";

    void HandleEntityInRange(CBaseMonster@ pEntityInRange, bool bIsFriendly)
    {
      // TODO: Make customizable
      if (bIsFriendly)
        pEntityInRange.TakeHealth(1.0f, 1);

      SetITouched(pEntityInRange, 1);

      if (EntWasAlreadyInRange(pEntityInRange))
        return;

      if (bIsFriendly && m_bShouldFriendliesGlow)
        StartGlow(pEntityInRange, true);

      if (!bIsFriendly && m_bShouldEnemiesGlow)
        StartGlow(pEntityInRange, false);

      entsInRange.insertLast(pEntityInRange);
    }

    // BUG: Something in this function is causing the game to crash when a friendly in range is killed
    void CleanUp()
    {
      for (uint i = 0; i < entsInRange.length(); i++)
      {
        CBaseMonster@ currentEnt = entsInRange[i];

        if (currentEnt is null)
        {
          entsInRange.removeAt(i);
          g_Game.AlertMessage(at_error, "Monster in the `entsInRange` collection was null somehow.\n");
          continue;
        }

        if (!currentEnt.IsAlive())
        {
          StopGlow(currentEnt);
          entsInRange.removeAt(i);
          continue;
        }

        int iTouched = GetITouched(currentEnt);
        if (iTouched == -1)
        {
          StopGlow(currentEnt);
          entsInRange.removeAt(i);
          g_Game.AlertMessage(at_error, "Monster was added to the `entsInRange` collection without setting iTouched first.\n");
          continue;
        }

        if (iTouched == 0)
        {
          StopGlow(currentEnt);
          entsInRange.removeAt(i);
          continue;
        }

        SetITouched(currentEnt, 0);
      }
    }

    private void SetITouched(CBaseMonster@ pMonster, const int value)
    {
    	CustomKeyvalues@ pCustomKeyValues = pMonster.GetCustomKeyvalues();
    	pCustomKeyValues.SetKeyvalue(iHasBeenTouchedKey, value);
    }

    private int GetITouched(CBaseMonster@ pMonster)
    {
      CustomKeyvalues@ pCustomKeyvals = pMonster.GetCustomKeyvalues();
      CustomKeyvalue pCustomKeyval = pCustomKeyvals.GetKeyvalue(iHasBeenTouchedKey);
      return pCustomKeyval.Exists() ? pCustomKeyval.GetInteger() : -1;
    }

    private bool EntWasAlreadyInRange(CBaseMonster@ pNeedleEnt)
    {
      for (uint i = 0; i < entsInRange.length(); i++)
      {
        if (entsInRange[i].opEquals(pNeedleEnt))
          return true;
      }

      return false;
    }

    private void StartGlow(CBaseMonster@ pMonster, bool bIsFriendly)
    {
      pMonster.pev.rendermode = kRenderNormal;
      pMonster.pev.renderfx = kRenderFxGlowShell;
      pMonster.pev.renderamt = 4;
      pMonster.pev.rendercolor = bIsFriendly ? m_vFriendlyGlowColor : m_vEnemyGlowColor;
    }

    private void StopGlow(CBaseMonster@ pMonster)
    {
      pMonster.pev.rendermode = kRenderNormal;
      pMonster.pev.renderfx = kRenderNormal;
    }
  }
}
