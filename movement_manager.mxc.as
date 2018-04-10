namespace FuncPayload
{
  enum FuncPayloadFlags
  {
  	SF_PAYLOAD_NOPITCH = 1 << 0
  };

  /**
   * Movement Manager
   * Responsible for containing code related to moving, stopping, and pathing the payload.
   */
  mixin class mxCMovementManager
  {
    CPathTrack@ pCurrentPath;
    float local_flMaxSpeed = m_flMaxSpeed;
    float local_flSpeedMultiplier = m_flSpeedMultiplier;

    void MovePayloadToFirstTarget()
    {
      @pCurrentPath = GetPathTrackByTarget(self.pev.target);
      Vector vAdjustedDestination = pCurrentPath.pev.origin;

      // NOTE: Adjust for the "Height above track" property
      vAdjustedDestination.z += m_flHeight;
      g_EntityFuncs.SetOrigin(self, vAdjustedDestination);

      // NOTE: This is done to ensure the payload is facing the direction expected by the angle calculations
      self.pev.angles.y += 180;
    }

    void Next()
    {
      Vector vDestination = self.pev.origin;
      float flDistance = GetCurrentAdjustedSpeed() * THINK_TIME;

      // NOTE: Adjust for the "Height above track" property
      vDestination.z -= m_flHeight;
      CPathTrack@ pNextPath = pCurrentPath.LookAhead(vDestination, vDestination, flDistance, false);
      vDestination.z += m_flHeight;

      Vector vDelta = vDestination - self.pev.origin;
      Vector vAngles = Math.VecToAngles(vDelta);

      // NOTE: This is done to ensure the payload is facing the direction expected by the angle calculations
      vAngles.y += 180;

      if (pNextPath is null || (vDelta.x == 0 && vDelta.y == 0))
        vAngles = self.pev.angles;

      // NOTE: At a dead end
      if (pNextPath is null)
      {
        StopMoving();
        FirePathTarget(pCurrentPath);
        return;
      }

      if (pNextPath != pCurrentPath)
      {
        CPathTrack@ pFire = self.pev.speed >= 0 ? pNextPath : pCurrentPath;
        FirePathTarget(pFire);
        UpdateSpeedsFromPath(pFire);
        @pCurrentPath = pNextPath;
      }

      // NOTE: Not sure what the significance of 10 is here
      self.pev.velocity = (vDestination - self.pev.origin) * 10;
      self.pev.avelocity = CalculateNewAngularVelocity(vAngles);
    }

    void FirePathTarget(CPathTrack@ pFire)
    {
      if (string(pFire.pev.message).IsEmpty())
        return;

      g_EntityFuncs.FireTargets(string(pFire.pev.message), self, self, USE_TOGGLE, 0);

      if (pFire.pev.SpawnFlagBitSet(SF_PATH_FIREONCE))
        pFire.pev.message = 0;
    }

    void UpdateSpeedsFromPath(CPathTrack@ pFire)
    {
      if (pFire.pev.speed != 0)
        ForceSetSpeed(pFire.pev.speed);

      if (pFire.m_flMaxSpeed >= 0)
        SetMaxSpeed(pFire.m_flMaxSpeed);

      if (pFire.m_flMaxSpeed == -1)
        SetMaxSpeed(m_flMaxSpeed);

      if (pFire.m_flNewSpeed >= 0)
        SetSpeed(pFire.m_flNewSpeed);

      if (pFire.m_flNewSpeed == -1)
        SetSpeed(m_flStartSpeed);
    }

    // NOTE: The outcome of this function depends on the payload's angles and
    //       velocity when it's called
    Vector CalculateNewAngularVelocity(Vector vAngles)
    {
      float flNewX;
      if(self.pev.SpawnFlagBitSet(SF_PAYLOAD_NOPITCH))
        flNewX = 0;
      else
        flNewX = Math.AngleDistance(vAngles.x, self.pev.angles.x) * 10;

      // TODO: Add custom keyval for maximum pitch
      flNewX = flNewX > 45 ? 45.0 : flNewX;
      flNewX = flNewX < -45 ? -45.0 : flNewX;

      Vector vNewAVelocity = self.pev.avelocity;
      vNewAVelocity.x = flNewX;
      vNewAVelocity.y = Math.AngleDistance(vAngles.y, self.pev.angles.y) * 10;

      if (m_flBank == 0)
        return vNewAVelocity;

      float flBank = 0;
      if (vNewAVelocity.y < -5)
        flBank = -m_flBank;

      if (vNewAVelocity.y > 5)
        flBank = m_flBank;

      vNewAVelocity.z = Math.AngleDistance(Math.ApproachAngle(flBank, self.pev.angles.z, m_flBank * 4), self.pev.angles.z) * 4;
      return vNewAVelocity;
    }

    // NOTE: This is when an entity is in front of the payload, not necessarily contested
    void Blocked(CBaseEntity@ pBlockingEnt)
    {
      Vector vNormalizedTrajectory = (pBlockingEnt.pev.origin - self.pev.origin).Normalize();

      if (self.pev.dmg <= 0)
      {
        pBlockingEnt.pev.velocity = vNormalizedTrajectory * 150;
        return;
      }

      pBlockingEnt.pev.velocity = vNormalizedTrajectory * self.pev.dmg;
      pBlockingEnt.TakeDamage(self.pev, self.pev, self.pev.dmg, DMG_CRUSH);
    }

    // NOTE: For legacy support, ignores max speed limit
    void ForceSetSpeed(float flNewSpeed)
    {
      self.pev.speed = flNewSpeed;
    }

    void SetSpeed(float flNewSpeed)
    {
      self.pev.speed = Math.min(flNewSpeed, local_flMaxSpeed);
    }

    void SetMaxSpeed(float flNewMaxSpeed)
    {
      local_flMaxSpeed = flNewMaxSpeed;
      pev.impulse = int(local_flMaxSpeed);
      SetSpeed(pev.speed);
    }

    void SetSpeedMultiplier(float flMultiplier)
    {
      local_flSpeedMultiplier = flMultiplier;
    }

    float GetCurrentAdjustedSpeed()
    {
      return Math.min(self.pev.speed * local_flSpeedMultiplier, local_flMaxSpeed);
    }

    void StopMoving()
    {
      self.pev.velocity = g_vecZero;
      self.pev.avelocity = g_vecZero;
    }

    CPathTrack@ GetPathTrackByTarget(string target)
    {
      CPathTrack@ pPath = cast<CPathTrack@>(g_EntityFuncs.FindEntityByTargetname(null, target));
      if (pPath is null)
        return null;

      if (!pPath.pev.ClassNameIs("path_track"))
      {
        g_Game.AlertMessage(at_error, "func_payload requires path_track\n");
        return null;
      }

      return pPath;
    }
  }
}