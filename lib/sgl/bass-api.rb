# Copyright (C) 2004-2007 Kouichirou Eto, All rights reserved.
# License: Ruby License

module Bass
  # ============================================================
  # Define result codes.
  BASS_OK		= 0	# all is OK
  BASS_ERROR_MEM	= 1	# memory error
  BASS_ERROR_FILEOPEN	= 2	# can't open the file
  BASS_ERROR_DRIVER	= 3	# can't find a free/valid driver
  BASS_ERROR_BUFLOST	= 4	# the sample buffer was lost - please report this!
  BASS_ERROR_HANDLE	= 5	# invalid handle
  BASS_ERROR_FORMAT	= 6	# unsupported format
  BASS_ERROR_POSITION	= 7	# invalid playback position
  BASS_ERROR_INIT	= 8	# BASS_Init has not been successfully called
  BASS_ERROR_START	= 9	# BASS_Start has not been successfully called
  BASS_ERROR_INITCD	= 10	# can't initialize CD
  BASS_ERROR_CDINIT	= 11	# BASS_CDInit has not been successfully called
  BASS_ERROR_NOCD	= 12	# no CD in drive
  BASS_ERROR_CDTRACK	= 13	# can't play the selected CD track
  BASS_ERROR_ALREADY	= 14	# already initialized
  BASS_ERROR_CDVOL	= 15	# CD has no volume control
  BASS_ERROR_NOPAUSE	= 16	# not paused
  BASS_ERROR_NOTAUDIO	= 17	# not an audio track
  BASS_ERROR_NOCHAN	= 18	# can't get a free channel
  BASS_ERROR_ILLTYPE	= 19	# an illegal type was specified
  BASS_ERROR_ILLPARAM	= 20	# an illegal parameter was specified
  BASS_ERROR_NO3D	= 21	# no 3D support
  BASS_ERROR_NOEAX	= 22	# no EAX support
  BASS_ERROR_DEVICE	= 23	# illegal device number
  BASS_ERROR_NOPLAY	= 24	# not playing
  BASS_ERROR_FREQ	= 25	# illegal sample rate
  BASS_ERROR_NOA3D	= 26	# A3D.DLL is not installed
  BASS_ERROR_NOTFILE	= 27	# the stream is not a file stream (WAV/MP3/MP2/MP1/OGG)
  BASS_ERROR_NOHW	= 29	# no hardware voices available
  BASS_ERROR_NOSYNC	= 30	# synchronizers have been disabled
  BASS_ERROR_EMPTY	= 31	# the MOD music has no sequence data
  BASS_ERROR_NONET	= 32	# no internet connection could be opened
  BASS_ERROR_CREATE	= 33	# couldn't create the file
  BASS_ERROR_NOFX	= 34	# effects are not enabled
  BASS_ERROR_PLAYING	= 35	# the channel is playing
  BASS_ERROR_NOOGG	= 36	# OGG.DLL/VORBIS.DLL could not be loaded
  BASS_ERROR_UNKNOWN	= -1	# some other mystery error

  # Device setup flags
  BASS_DEVICE_8BITS	= 1	# use 8 bit resolution, else 16 bit
  BASS_DEVICE_MONO	= 2	# use mono, else stereo
  BASS_DEVICE_3D	= 4	# enable 3D functionality

  # If the BASS_DEVICE_3D flag is not specified when initilizing BASS,
  # then the 3D flags (BASS_SAMPLE_3D and BASS_MUSIC_3D) are ignored when
  # loading/creating a sample/stream/music.
  BASS_DEVICE_A3D	= 8	# enable A3D functionality
  BASS_DEVICE_NOSYNC	= 16	# disable synchronizers
  BASS_DEVICE_LEAVEVOL	= 32	# leave the volume as it is
  BASS_DEVICE_OGG	= 64	# enable OGG support (requires OGG.DLL & VORBIS.DLL)

  # DirectSound interfaces (for use with BASS_GetDSoundObject)
  BASS_OBJECT_DS	= 1	# IDirectSound
  BASS_OBJECT_DS3DL	= 2	# IDirectSound3DListener

  # Music flags
  BASS_MUSIC_RAMP	= 1	# normal ramping
  BASS_MUSIC_RAMPS	= 2	# sensitive ramping
  # Ramping doesn't take a lot of extra processing and improves '
  # the sound quality by removing 'clicks'. Sensitive ramping will
  # leave sharp attacked samples, unlike normal ramping.
  BASS_MUSIC_LOOP	= 4	# loop music
  BASS_MUSIC_FT2MOD	= 16	# play .MOD as FastTracker 2 does
  BASS_MUSIC_PT1MOD	= 32	# play .MOD as ProTracker 1 does
  BASS_MUSIC_MONO	= 64	# force mono mixing (less CPU usage)
  BASS_MUSIC_3D		= 128	# enable 3D functionality
  BASS_MUSIC_POSRESET	= 256	# stop all notes when moving position
  BASS_MUSIC_SURROUND	= 512	# surround sound
  BASS_MUSIC_SURROUND2	= 1024	# surround sound (mode 2)
  BASS_MUSIC_STOPBACK	= 2048	# stop the music on a backwards jump effect
  BASS_MUSIC_FX		= 4096	# enable DX8 effects
  BASS_MUSIC_CALCLEN	= 8192	# calculate playback length

  BASS_SAMPLE_8BITS	= 1	# 8 bit, else 16 bit
  BASS_SAMPLE_MONO	= 2	# mono, else stereo
  BASS_SAMPLE_LOOP	= 4	# looped
  BASS_SAMPLE_3D	= 8	# 3D functionality enabled
  BASS_SAMPLE_SOFTWARE	= 16	# it's NOT using hardware mixing'
  BASS_SAMPLE_MUTEMAX	= 32	# muted at max distance (3D only)
  BASS_SAMPLE_VAM	= 64	# uses the DX7 voice allocation & management
  BASS_SAMPLE_FX	= 128	# the DX8 effects are enabled
  BASS_SAMPLE_OVER_VOL	= 0x10000	# override lowest volume
  BASS_SAMPLE_OVER_POS	= 0x20000	# override longest playing
  BASS_SAMPLE_OVER_DIST	= 0x30000	# override furthest from listener (3D only)

  BASS_MP3_HALFRATE	= 0x10000	# reduced quality MP3/MP2/MP1 (half sample rate)
  BASS_MP3_SETPOS	= 0x20000	# enable seeking on the MP3/MP2/MP1/OGG

  BASS_STREAM_AUTOFREE	= 0x40000	# automatically free the stream when it stop/ends
  BASS_STREAM_RESTRATE	= 0x80000	# restrict the download rate of internet file streams
  BASS_STREAM_BLOCK	= 0x100000	# download/play internet file stream (MPx/OGG) in small blocks

  BASS_CDID_IDENTITY	= 0
  BASS_CDID_UPC		= 1

  # ============================================================
  # Load API.

  def api(func, input, output)
    return Win32API.new('bass', func, input, output)    
  end
  module_function :api

  BASS_GetVersion	= api('BASS_GetVersion', 'V', 'L')
  BASS_GetDeviceDescription	= api('BASS_GetDeviceDescription', 'IP', 'I')
  BASS_SetBufferLength	= api('BASS_SetBufferLength', 'L', 'V')
  BASS_SetGlobalVolumes	= api('BASS_SetGlobalVolumes', 'III', 'V')
  BASS_GetGlobalVolumes	= api('BASS_GetGlobalVolumes', 'PPP', 'V')
  BASS_SetLogCurves	= api('BASS_SetLogCurves', 'II', 'V')
  BASS_Set3DAlgorithm	= api('BASS_Set3DAlgorithm', 'L', 'V')
  BASS_ErrorGetCode	= api('BASS_ErrorGetCode', 'V', 'I')
  BASS_Init		= api('BASS_Init', 'ILLP', 'I')
  BASS_Free		= api('BASS_Free', 'V', 'V')
  BASS_GetDSoundObject	= api('BASS_GetDSoundObject', 'L', 'P')
  BASS_GetInfo		= api('BASS_GetInfo', 'P', 'V')
  BASS_GetCPU		= api('BASS_GetCPU', 'V', 'L')
  BASS_Start		= api('BASS_Start', 'V', 'I')
  BASS_Stop		= api('BASS_Stop', 'V', 'I')
  BASS_Pause		= api('BASS_Pause', 'V', 'I')
  BASS_SetVolume	= api('BASS_SetVolume', 'L', 'I')
  BASS_GetVolume	= api('BASS_GetVolume', 'V', 'I')
  BASS_Set3DFactors	= api('BASS_Set3DFactors', 'LLL', 'I')
  BASS_Get3DFactors	= api('BASS_Get3DFactors', 'PPP', 'I')
  BASS_Set3DPosition	= api('BASS_Set3DPosition', 'PPPP', 'I')
  BASS_Get3DPosition	= api('BASS_Get3DPosition', 'PPPP', 'I')
  BASS_Apply3D	= api('BASS_Apply3D', 'V', 'I')
  BASS_SetEAXParameters	= api('BASS_SetEAXParameters', 'ILLL', 'I')
  BASS_GetEAXParameters	= api('BASS_GetEAXParameters', 'PPPP', 'I')
#BASS_SetA3DResManager	= api('BASS_SetA3DResManager', 'L', 'I')
#BASS_GetA3DResManager	= api('BASS_GetA3DResManager', 'V', 'L')
#BASS_SetA3DHFAbsorbtion	= api('BASS_SetA3DHFAbsorbtion', 'L', 'I')
#BASS_GetA3DHFAbsorbtion	= api('BASS_GetA3DHFAbsorbtion', 'P', 'I')
  BASS_MusicLoad	= api('BASS_MusicLoad', 'IPLLL', 'L')
  BASS_MusicFree	= api('BASS_MusicFree', 'P', 'V')
  BASS_MusicGetName	= api('BASS_MusicGetName', 'P', 'P')
  BASS_MusicGetLength	= api('BASS_MusicGetLength', 'PI', 'L')
  BASS_MusicPreBuf	= api('BASS_MusicPreBuf', 'P', 'I')
  BASS_MusicPlay	= api('BASS_MusicPlay', 'P', 'I')
  BASS_MusicPlayEx	= api('BASS_MusicPlayEx', 'PLII', 'I')
  BASS_MusicSetAmplify	= api('BASS_MusicSetAmplify', 'PL', 'I')
  BASS_MusicSetPanSep	= api('BASS_MusicSetPanSep', 'PL', 'I')
  BASS_MusicSetPositionScaler	= api('BASS_MusicSetPositionScaler', 'PL', 'I')
  BASS_SampleLoad	= api('BASS_SampleLoad', 'IPLLLL', 'L')
  BASS_SampleCreate	= api('BASS_SampleCreate', 'LLLL', 'L')
  BASS_SampleCreateDone	= api('BASS_SampleCreateDone', 'V', 'P')
  BASS_SampleFree	= api('BASS_SampleFree', 'P', 'V')
  BASS_SampleGetInfo	= api('BASS_SampleGetInfo', 'PP', 'I')
  BASS_SampleSetInfo	= api('BASS_SampleSetInfo', 'PP', 'I')
  BASS_SamplePlay	= api('BASS_SamplePlay', 'L', 'L')
  BASS_SamplePlayEx	= api('BASS_SamplePlayEx', 'PLIIII', 'L')
  BASS_SamplePlay3D	= api('BASS_SamplePlay3D', 'PPPP', 'P')
  BASS_SamplePlay3DEx	= api('BASS_SamplePlay3DEx', 'PPPPLIII', 'P')
  BASS_SampleStop	= api('BASS_SampleStop', 'P', 'I')
  BASS_StreamCreate	= api('BASS_StreamCreate', 'LLPL', 'P')
  BASS_StreamCreateFile	= api('BASS_StreamCreateFile', 'IPLLL', 'P')
  BASS_StreamCreateURL	= api('BASS_StreamCreateURL', 'PLP', 'P')
  BASS_StreamFree	= api('BASS_StreamFree', 'P', 'V')
  BASS_StreamGetLength	= api('BASS_StreamGetLength', 'P', 'L')
  BASS_StreamPreBuf	= api('BASS_StreamPreBuf', 'P', 'I')
  BASS_StreamPlay	= api('BASS_StreamPlay', 'PIL', 'I')
  BASS_StreamGetFilePosition	= api('BASS_StreamGetFilePosition', 'PL', 'L')
  BASS_CDInit		= api('BASS_CDInit', 'P', 'I')
  BASS_CDFree		= api('BASS_CDFree', 'V', 'V')
  BASS_CDInDrive	= api('BASS_CDInDrive', 'V', 'I')
  BASS_CDGetID		= api('BASS_CDGetID', 'L', 'P')
  BASS_CDGetTracks	= api('BASS_CDGetTracks', 'V', 'L')
  BASS_CDPlay		= api('BASS_CDPlay', 'LII', 'I')
  BASS_CDGetTrackLength	= api('BASS_CDGetTrackLength', 'L', 'L')
  BASS_ChannelIsActive	= api('BASS_ChannelIsActive', 'P', 'I')
  BASS_ChannelGetFlags	= api('BASS_ChannelGetFlags', 'L', 'L')
  BASS_ChannelStop	= api('BASS_ChannelStop', 'L', 'I')
  BASS_ChannelPause	= api('BASS_ChannelPause', 'L', 'I')
  BASS_ChannelResume	= api('BASS_ChannelResume', 'L', 'I')
  BASS_ChannelSetAttributes	= api('BASS_ChannelSetAttributes', 'LIII', 'I')
  BASS_ChannelGetAttributes	= api('BASS_ChannelGetAttributes', 'LPPP', 'I')
  BASS_ChannelSet3DAttributes	= api('BASS_ChannelSet3DAttributes', 'LILLIII', 'I')
  BASS_ChannelGet3DAttributes	= api('BASS_ChannelGet3DAttributes', 'LPPPPPP', 'I')
  BASS_ChannelSet3DPosition	= api('BASS_ChannelSet3DPosition', 'LPPP', 'I')
  BASS_ChannelGet3DPosition	= api('BASS_ChannelGet3DPosition', 'LPPP', 'I')
  BASS_ChannelSetPosition	= api('BASS_ChannelSetPosition', 'LL', 'I')
  BASS_ChannelGetPosition	= api('BASS_ChannelGetPosition', 'L', 'L')
  BASS_ChannelGetLevel	= api('BASS_ChannelGetLevel', 'L', 'L')
  BASS_ChannelGetData	= api('BASS_ChannelGetData', 'LPL', 'L')
  BASS_ChannelSetSync	= api('BASS_ChannelSetSync', 'LLLPL', 'P')
  BASS_ChannelRemoveSync	= api('BASS_ChannelRemoveSync', 'LP', 'I')
  BASS_ChannelSetDSP	= api('BASS_ChannelSetDSP', 'LPL', 'P')
  BASS_ChannelRemoveDSP	= api('BASS_ChannelRemoveDSP', 'LP', 'I')
  BASS_ChannelSetFX	= api('BASS_ChannelSetFX', 'LL', 'P')
  BASS_ChannelRemoveFX	= api('BASS_ChannelRemoveFX', 'LP', 'I')
  BASS_ChannelSetEAXMix	= api('BASS_ChannelSetEAXMix', 'LL', 'I')
  BASS_ChannelGetEAXMix	= api('BASS_ChannelGetEAXMix', 'LP', 'I')
  BASS_ChannelSetLink	= api('BASS_ChannelSetLink', 'LL', 'I')
  BASS_ChannelRemoveLink	= api('BASS_ChannelRemoveLink', 'LL', 'I')
  BASS_FXSetParameters	= api('BASS_FXSetParameters', 'PP', 'I')
  BASS_FXGetParameters	= api('BASS_FXGetParameters', 'PP', 'I')
end
