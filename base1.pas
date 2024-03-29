unit BaseClasses;

interface

uses
  System.SysUtils, System.Generics.Collections, Vcl.Graphics, Math, StrUtils;

type
  TSkill = class      // - OK - // можно сделать чтоб скилы влияли на разные способности - атаку, крит, защиту и т.п.
    fName: string;
    fIsMelee: boolean; // можно юзать при боевой проверке ----- тест гита ---- второе изменение !!!! *****
    constructor Create(Name: string; IsMelee: boolean);
  end;

  TSkillArray = array of TSkill;


  TAttribute = class     // - OK - //
    fName: string;
    constructor Create(Name: string);
  end;

  TAttributeArray = array of TAttribute;


  THeroSkill = class       // - OK - //
    fSkill: TSkill;
    fRollValue: Byte;
    fAddValue: Byte;
    fMainSkill: THeroSkill;
    constructor Create(Skill: TSkill; Main: THeroSkill; RollValue,AddValue: Byte);
    function GetRollValue: integer;
    function GetAddValue: integer;
    function GetRoll: integer;
    function GetMin: integer;
    function GetMax: integer;
  end;


  TCardType = class      // - OK - //
    fName: string;
    fColor: TColor;
    fIsForHand: boolean;
    constructor Create(Name: string; Color: TColor; IsForHand: boolean);
  end;

  TCardTypeArray = array of TCardType;


      TCardAction = (caReveal, caRecharge, caDiscard, caBury, caBanish); // действие с картой
      TCheckType = (ctFight, ctSkill);    // тип проверки при броске кубиков
      TCheckTypeSet = set of TCheckType;


  TCheckItem = class     // - OK - //
  end;

  TCheckItemArray = array of TCheckItem;


  TRollCheck = class (TCheckItem)   // - OK - // проверка броска на скил или бой
    fValue: Byte;
    fSkill: TSkill;   //------ если карта меняет скил, то добавляет ВСЕ свои атрибуты к проверке ------
    //fNeedAttr: TList<TAttribute>;    // необходимые атрибуты для прохождения проверки
    constructor Create(Value:Byte; Skill:TSkill{; NeedAttrArray:TAttributeArray});
    function GetAsString: string;
    function IsFight: boolean;
    function CheckType: TCheckType;
  end;
                            (*
  TCardActionCheck = class (TCheckItem) // провека на действие с картой (пример: для прохождения проверки сбросьте благословление)
   { fActionType: TCardAction;
    fCount: Byte;
    // далее фильтр по картам, т.е. какие карты доступны для выполнения действия
    fCardType: TCardType;
    fCardAttribute: TList<TAttribute>;
    fCard: TList<TCard>;   }
  end;

  TSummonCheck = class (TCheckItem)     // призвать хрена и сразиться
{    fCardType: TCardType;
    fCardAttribute: TList<TAttribute>;
    fCard: TList<TCard>;     }
  end;                                *)

  TCheckGroup = class    // - OK - // список условий с необходимостью выполнения одного из них
    fCheckOrList: TList<TCheckItem>;
    constructor Create(CheckItemArray: TCheckItemArray);
    procedure CopyFrom(cg: TCheckGroup);
    function GetString(delim: string): string;
    function GetMinRollCheck: TRollCheck;
    function GetSkillRollCheck(skill:TSkill): TRollCheck;  // для скила ищем возможную проверку (!!!) переделать  ----!!!!
    function IsHaveCheck: boolean;
  end;


      TMenuStage = (msMainMenu, msCreateGroup, msManageCard, msSelectLocation, msGame);
      TGameStage = (gsMove, gsFirstOpen, gsOpen, gsCheck, gsTakeDamage, gsDiscardEnd, gsEnd, gsTakeCard);
      TGameStageSet = set of TGameStage;


implementation
