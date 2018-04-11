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
    array<CBaseMonster@> previousEntsInRange = array<CBaseMonster@>();
    array<CBaseMonster@> entsInRange = array<CBaseMonster@>();

    void HandleEntityInRange(CBaseMonster@ pEntityInRange, bool bIsFriendly)
    {
      if (!EntWasAlreadyInRange(pEntityInRange))
        StartGlow(pEntityInRange, bIsFriendly);

      entsInRange.insertLast(pEntityInRange);
    }

    void CleanUp()
    {
      for (uint i = 0; i < previousEntsInRange.length(); i++)
      {
        if (!EntIsStillInRange(previousEntsInRange[i]))
          StopGlow(previousEntsInRange[i]);
      }

      previousEntsInRange = entsInRange;
      entsInRange = array<CBaseMonster@>();
    }

    private bool EntWasAlreadyInRange(CBaseMonster@ pNeedleEnt)
    {
      return FindEntInArray(pNeedleEnt, previousEntsInRange);
    }

    private bool EntIsStillInRange(CBaseMonster@ pNeedleEnt)
    {
      return FindEntInArray(pNeedleEnt, entsInRange);
    }

    private bool FindEntInArray(CBaseMonster@ pNeedleEnt, array<CBaseMonster@> haystack)
    {
      for (uint i = 0; i < haystack.length(); i++)
      {
        if (haystack[i].opEquals(pNeedleEnt))
          return true;
      }
      return false;
    }

    private void StartGlow(CBaseMonster@ pMonster, bool bIsFriendly)
    {
      if ((bIsFriendly && !m_bShouldFriendliesGlow) || (!bIsFriendly && !m_bShouldEnemiesGlow))
        return;

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
