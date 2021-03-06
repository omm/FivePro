/*
浜様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
� M�dulo: Stack.prg                                             �
� Lenguaje: Clipper 5.0x + ObjectsP                             �
� Fecha: Marzo  1993                                            �
� Compilar: Clipper Stack    /a /n /w                           �
� Desc.:Demo de clases: Stack Class                             �
�                                                               �
� (c) 1993 Francisco Pulp�n y Antonio Linares                   �
藩様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
*/

#include "ObjectsP.ch"


CLASS Stack

    HIDE DATA   aStack  AS  Array

    METHOD  New()         INLINE  ::aStack := {}, Self
    METHOD  Push( uVal )  INLINE  aadd( ::aStack, uVal ), uVal
    METHOD  Top()         INLINE  atail( ::aStack )
    METHOD  lEmpty()      INLINE  Empty( ::aStack )

    METHOD  Pull

ENDCLASS


METHOD Stack.Pull()

    local uRet, aStack := ::aStack

    if !Empty( aStack )

        uRet = aTail( aStack )
        aSize( aStack, len( aStack ) - 1 )

    endif

Return uRet
