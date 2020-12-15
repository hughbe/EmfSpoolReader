//
//  SpecVersion.swift
//  
//
//  Created by Hugh Bellamy on 09/12/2020.
//

/// [MS-EMFSPOOL] 2.1.2 SpecVersion Enumeration
/// The SpecVersion enumeration specifies Windows system versions, for comparison with printer driver versions.
/// typedef enum
/// {
///  _WIN32_WINNT_NT4 = 0x0400,
///  _WIN32_WINNT_WIN2K = 0x0500,
///  _WIN32_WINNT_WINXP = 0x0501,
///  _WIN32_WINNT_WS03 = 0x0502,
///  _WIN32_WINNT_VISTA = 0x0600,
///  _WIN32_WINNT_WIN7 = 0x0601,
///  _WIN32_WINNT_WIN8 = 0x0602
/// } SpecVersion;
public enum SpecVersion: UInt16, DataStreamCreatable {
    /// _WIN32_WINNT_NT4: Windows NT 4.0 operating system
    case _WIN32_WINNT_NT4 = 0x0400
    
    /// _WIN32_WINNT_WIN2K: Windows 2000 operating system
    case _WIN32_WINNT_WIN2K = 0x0500
    
    /// _WIN32_WINNT_WINXP: Windows XP operating system
    case _WIN32_WINNT_WINXP = 0x0501
    
    /// _WIN32_WINNT_WS03: Windows Server 2003 operating system
    case _WIN32_WINNT_WS03 = 0x0502
    
    /// _WIN32_WINNT_VISTA: Windows Vista operating system and Windows Server 2008 operating system
    case _WIN32_WINNT_VISTA = 0x0600
    
    /// _WIN32_WINNT_WIN7: Windows 7 operating system and Windows Server 2008 R2 operating system
    case _WIN32_WINNT_WIN7 = 0x0601
    
    /// _WIN32_WINNT_WIN8: Windows 8 operating system and Windows Server 2012 operating system
    case _WIN32_WINNT_WIN8 = 0x0602
}
