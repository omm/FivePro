/*
浜様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
�    ObjectsP.ch                                                �
�                                                               �
� Clipper 5.x header file for ObjectsP.lib  V 2.5 (Profesional) �
� Fecha: Marzo 1994                                             �
�                                                               �
� (c) 1994 Francisco Pulp�n y Antonio Linares                   �
藩様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�

    � Dios libre al Sr. Usuario de cambiar una sola linea de
    este fichero sin haber hecho antes una copia de seguridad !

*/

#ifndef _OBJECTSP_CH
#define _OBJECTSP_CH

#define _FuncType_

#xcommand DEFAULT <Desc> [, <DescN> ]      => ;
                  __DFT__( <Desc> ) [ ; __DFT__( <DescN> ) ]

#xtranslate __DFT__( <Var> := <Dft> ) => ;
                     <Var> := BYDEFAULT <Var>, <Dft>

#xtranslate __DFT__( <Var> = <Dft> )  => ;
            __DFT__( <Var> := <Dft> )

// Una preciosa idea de Carlos Ruiz
#xtranslate BYNAME <V> [, <VN> ]     => ::<V> := <V> [; ::<VN> := <VN> ]
#xtranslate BYNAME <V> DEFAULT <Val> => ::<V> := BYDEFAULT <V>, <Val>
#xtranslate BYDEFAULT <V>, <Val>     => if( <V> == NIL, <Val>, <V> )


// Declaracion de clase
// =======================

// El "Ambito" (Scope) por defecto inicial es PUBLIC. Lo pone _NewClass().

#xcommand CLASS <ClsNam>   ;
            [ <from: INHERIT FROM, INHERIT, FROM, OF> <SupCls> ] ;
    => ;
          function _AsFunc_( <ClsNam> )  ;;
             static nClassH                ;;
             local Self [ := _AsFunc_( <SupCls> ) ] ;;
             if nClassH == nil          ;;
                nClassH = _NewClass( _AsStr_( <ClsNam> ), Self ) ;
                [ ; #define _sUPcLS_ _AsName_( <SupCls> ) ]

#xtranslate CREATE CLASS <*ClsHead*> =>  CLASS <ClsHead>


// Declaraciones de Variables de Instancia y de Clase.
// ===================================================

#xcommand _GEN_DATA_ <vt>, <Vrs,...> [ AS <Typ,...> ] ;
         [ <scp: PUBLIC, EXPORT, READONLY, PROTECTED, LOCAL, HIDDEN> ] =>  ;
         _AddMethod( _AsStrLst_( <Vrs> ), [ _AsUppLst_( <Typ> ) ], ;
                    __SCOPE__ [ <scp> ], <vt> )

// Declaraciones de Variables de Instancia

#xcommand VAR     <*VLst*>   => _GEN_DATA_  1, <VLst>
#xcommand INSTVAR <*VLst*>   => VAR <VLst>
#xcommand DATA    <*VLst*>   => VAR <VLst>

// Declaraciones de Variables de Clase.

#xcommand CLASSVAR  <*VLst*>   => _GEN_DATA_ 2, <VLst>
#xcommand CLASSDATA <*VLst*>   => CLASSVAR <VLst>


// Declaraciones de Metodos.
// =========================

#xcommand __METHOD__ <Met> [, <MetN> ] [ <scp: PUBLIC, EXPORT, LOCAL, HIDDEN> ] [ <CONSTRUCTOR> ] => ;
   _AddMethod(\{_MetTrans_(<Met>) [,_MetTrans_(<MetN>)]\}, __SCOPE__ [ <scp> ], <.CONSTRUCTOR.>, 0 )

#xcommand _GEN_METHOD_ <Met> [,<MetN> ] [<*x*>] =>  ;
          __METHOD__  <Met> [,<MetN> ]  [<x>]

#xcommand _GEN_METHOD_ <Met> VIRTUAL [<*x*>] => __METHOD__ <Met>:_VIRTUAL_ [<x>]

// Una GENIAL idea de Antonio Linares: La declaraci�n "SetGet"
#xcommand _GEN_METHOD_ <Met> SETGET [<*x*>]  => __METHOD__ <Met>:_SETGET_ [<x>]

#xcommand _GEN_METHOD_ <Met> METHOD <udf> [, <MetN> METHOD <udfN> ] [<*x*>] => ;
          __METHOD__ <Met> = <udf> [ , <MetN> = <udfN> ] [<x>]

#xcommand _GEN_METHOD_ <Met> <code: EXTERN, CFUNC, CMETHOD> <udf> [<*x*>] => ;
          EXTERNAL _AsName_( <udf> ) ;;
          _AddMethod(\{ _AsStr_(<Met>), _AsStr_( <udf> ) \}, __SCOPE__, .f., 0 )

#xcommand _GEN_METHOD_ <Met> <o: BLOCK, INLINE> <code,...> [ <scp: PUBLIC, EXPORT, LOCAL, HIDDEN> ] => ;
          _AddMethod( _BlkTrans_( <Met> <o> <code> ), __SCOPE__ [<scp>], 3 )

#xcommand MESSAGE <*cMDesc*>   => _GEN_METHOD_ <cMDesc>


// PreAmbitos
#xcommand  __ST__  <st: METHOD, MESSAGE, VAR, INSTVAR, DATA, CLASSVAR, CLASSDATA > <*x*> ;
                  => <st> <x>
#xcommand EXPORT  <*x*> => __ST__ <x> PUBLIC
#xcommand HIDE    <*x*> => __ST__ <x> HIDDEN
#xcommand PROTECT <*x*> => __ST__ <x> PROTECTED


// Declaraciones de Scoping por defecto.
// =======================================
#xcommand EXPORT:     =>   _DftScope( 0 )
#xcommand PUBLIC:     =>   EXPORT:
#xcommand PROTECTED:  =>   _DftScope( 1 )
#xcommand READONLY:   =>   PROTECTED:
#xcommand LOCAL:      =>   _DftScope( 2 )
#xcommand HIDDEN:     =>   LOCAL:


// Traductores de descripciones de m�todos.

#xtranslate _MetTrans_( <Met> ) => ;
            _AsStr_( <Met> ), \{|| _AsName_( <Met> )() \}

#xtranslate _MetTrans_( <Met> = <udf> ) => ;
            _AsStr_( <Met> ), \{|| _AsName_( <udf> )() \}

#xtranslate _MetTrans_( <Met>:_VIRTUAL_ ) => ;
            _AsStr_( <Met> ), "_VIRTUAL_"

#xtranslate _MetTrans_( <Met>:_SETGET_ ) => ;
            _AsStr_( <Met> ), \{|| _AsName_( <Met> )() \}, ;
            "_" + _AsStr_( <Met> ), \{|| _AsName_( <Met> )() \}

#xtranslate _BlkTrans_( <Met> INLINE <code,...> ) => ;
            #<Met>, \{ | Self | <code> \}

#xtranslate _BlkTrans_( <Met>( [<prm,...>] ) INLINE <code,...> ) => ;
            #<Met>, \{ | Self [, <prm> ] | <code> \}

#xtranslate _BlkTrans_( <Met> BLOCK <code,...> ) => ;
            _AsStr_( <Met> ), <code>

// Traductores Gen�ricos de <Func>[ ( [ <parms,..> ] ) ]

#xtranslate _AsFunc_( <itm> ) => <itm>()
#xtranslate _AsFunc_( <itm>( [<prm,...>] ) ) =>  <itm>( [<prm>] )

#xtranslate _AsName_( <itm> ) => <itm>
#xtranslate _AsName_( <itm>( [<prm,...>] ) ) =>  <itm>

#xtranslate _AsStr_( <itm> ) => #<itm>
#xtranslate _AsStr_( <itm>( [<prm,...>] ) ) =>  #<itm>
#xtranslate _AsUpp_( <itm> ) => upper( _AsStr_( <itm> ) )

#xtranslate _AsStrLst_( <Typ> [, <TypN> ] ) => ;
            \{ _AsStr_( <Typ> ) [, _AsStr_( <TypN> ) ] \}
#xtranslate _AsUppLst_( <Typ> [, <TypN> ] ) => ;
            \{ _AsUpp_( <Typ> ) [, _AsUpp_( <TypN> ) ] \}

#xtranslate __SCOPE__                                => NIL
#xtranslate __SCOPE__ <scp: PUBLIC, EXPORT>          => 0
#xtranslate __SCOPE__ <scp: READONLY, PROTECTED>     => 1
#xtranslate __SCOPE__ <scp: LOCAL, HIDDEN>           => 2

#xtranslate :VIRTUAL => :_VIRTUAL_
#xtranslate :SETGET  => :_SETGET_


#xcommand ENDCLASS  =>                                ;
                       end                           ;;
                       return __ClassIns( nClassH )  ;;
                       #include "obendcls.ch"

#xcommand END CLASS  => ENDCLASS

// Declaraciones para el c�digo ( funci�n � procedimiento ) de los m�todos.
// ==========================================================================

#xcommand _METHOD_ <Tp: FUNCTION, PROCEDURE> <Met> [ CLASS <ClassN> ] =>;
                  _FuncType_ <Tp> <Met>  ;;
                  local Self := QSelf()

#translate METHOD <Tp: FUNCTION, PROCEDURE> <*Met*> => ;
                 _METHOD_ <Tp> <Met>

#translate METHOD <ClassN>::<*Met*>        => ;
                 _METHOD_ FUNCTION <Met>

#translate METHOD <ClassN>.<*Met*>         => ;
                 _METHOD_ FUNCTION <Met>

//   Sixtaxis Parent / Super
//   =======================

#xtranslate :Parent( <SupCls> ):<*M*> => :<SupCls>:<M>

#xtranslate :Parent:<*M*>             => :_sUPcLS_:<M>

#xtranslate Super:<*M*>               => Self:_sUPcLS_:<M>

#xtranslate :Super  => :Parent

//   Self
//  ======
#xtranslate ::      =>    Self:

#else


#ifdef _sUPcLS_
#undef _sUPcLS_
#endif

#endif  // _OBJECTSP_CH

//---------------------------

  // Redefine el comando METHOD para la declaraci�nes de m�todos
  // en el bloque de clase.
  // Fue redefinido por el �ltimo "endclass" para declarar c�digo de m�todos.

#xcommand METHOD <*MDesc*> =>  _GEN_METHOD_ <MDesc>
