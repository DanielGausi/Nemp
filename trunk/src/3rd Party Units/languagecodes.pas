unit languagecodes;
// This unit is automatically generated from a language list.

interface

// Return the English name of the language specified as 2 or 5 char
// language codes, e.g. 'en' or 'en_GB'.
function getlanguagename(langcode:string):string;

implementation

function getlanguagename(langcode:string):string;
begin
  if langcode='aa' then Result:='Afar' else
  if langcode='ab' then Result:='Abkhazian' else
  if langcode='ae' then Result:='Avestan' else
  if langcode='af' then Result:='Afrikaans' else
  if langcode='ak' then Result:='Akan' else
  if langcode='am' then Result:='Amharic' else
  if langcode='an' then Result:='Aragonese' else
  if langcode='ar' then Result:='Arabic' else
  if langcode='as' then Result:='Assamese' else
  if langcode='av' then Result:='Avaric' else
  if langcode='ay' then Result:='Aymara' else
  if langcode='az' then Result:='Azerbaijani' else
  if langcode='ba' then Result:='Bashkir' else
  if langcode='be' then Result:='Belarusian' else
  if langcode='bg' then Result:='Bulgarian' else
  if langcode='bh' then Result:='Bihari' else
  if langcode='bi' then Result:='Bislama' else
  if langcode='bm' then Result:='Bambara' else
  if langcode='bn' then Result:='Bengali' else
  if langcode='bo' then Result:='Tibetan' else
  if langcode='br' then Result:='Breton' else
  if langcode='bs' then Result:='Bosnian' else
  if langcode='ca' then Result:='Catalan' else
  if langcode='ce' then Result:='Chechen' else
  if langcode='ch' then Result:='Chamorro' else
  if langcode='co' then Result:='Corsican' else
  if langcode='cr' then Result:='Cree' else
  if langcode='cs' then Result:='Czech' else
  if langcode='cv' then Result:='Chuvash' else
  if langcode='cy' then Result:='Welsh' else
  if langcode='da' then Result:='Danish' else
  if langcode='de' then Result:='German' else
  if langcode='de_DE' then Result:='German' else
  if langcode='de_AT' then Result:='Austrian German' else
  if langcode='de_CH' then Result:='Swiss German' else
  if langcode='dv' then Result:='Divehi' else
  if langcode='dz' then Result:='Dzongkha' else
  if langcode='ee' then Result:='Ewe' else
  if langcode='el' then Result:='Greek' else
  if langcode='en' then Result:='English' else
  if langcode='en_AU' then Result:='Australian English' else
  if langcode='en_CA' then Result:='Canadian English' else
  if langcode='en_GB' then Result:='British English' else
  if langcode='en_US' then Result:='American English' else
  if langcode='eo' then Result:='Esperanto' else
  if langcode='es' then Result:='Spanish' else
  if langcode='et' then Result:='Estonian' else
  if langcode='eu' then Result:='Basque' else
  if langcode='fa' then Result:='Persian' else
  if langcode='ff' then Result:='Fulah' else
  if langcode='fi' then Result:='Finnish' else
  if langcode='fj' then Result:='Fijian' else
  if langcode='fo' then Result:='Faroese' else
  if langcode='fr' then Result:='French' else
  if langcode='fr_BE' then Result:='Walloon' else
  if langcode='fy' then Result:='Frisian' else
  if langcode='ga' then Result:='Irish' else
  if langcode='gd' then Result:='Gaelic' else
  if langcode='gl' then Result:='Gallegan' else
  if langcode='gn' then Result:='Guarani' else
  if langcode='gu' then Result:='Gujarati' else
  if langcode='gv' then Result:='Manx' else
  if langcode='ha' then Result:='Hausa' else
  if langcode='he' then Result:='Hebrew' else
  if langcode='hi' then Result:='Hindi' else
  if langcode='ho' then Result:='Hiri Motu' else
  if langcode='hr' then Result:='Croatian' else
  if langcode='ht' then Result:='Haitian' else
  if langcode='hu' then Result:='Hungarian' else
  if langcode='hy' then Result:='Armenian' else
  if langcode='hz' then Result:='Herero' else
  if langcode='ia' then Result:='Interlingua' else
  if langcode='id' then Result:='Indonesian' else
  if langcode='ie' then Result:='Interlingue' else
  if langcode='ig' then Result:='Igbo' else
  if langcode='ii' then Result:='Sichuan Yi' else
  if langcode='ik' then Result:='Inupiaq' else
  if langcode='io' then Result:='Ido' else
  if langcode='is' then Result:='Icelandic' else
  if langcode='it' then Result:='Italian' else
  if langcode='iu' then Result:='Inuktitut' else
  if langcode='ja' then Result:='Japanese' else
  if langcode='jv' then Result:='Javanese' else
  if langcode='ka' then Result:='Georgian' else
  if langcode='kg' then Result:='Kongo' else
  if langcode='ki' then Result:='Kikuyu' else
  if langcode='kj' then Result:='Kuanyama' else
  if langcode='kk' then Result:='Kazakh' else
  if langcode='kl' then Result:='Greenlandic' else
  if langcode='km' then Result:='Khmer' else
  if langcode='kn' then Result:='Kannada' else
  if langcode='ko' then Result:='Korean' else
  if langcode='kr' then Result:='Kanuri' else
  if langcode='ks' then Result:='Kashmiri' else
  if langcode='ku' then Result:='Kurdish' else
  if langcode='kw' then Result:='Cornish' else
  if langcode='kv' then Result:='Komi' else
  if langcode='ky' then Result:='Kirghiz' else
  if langcode='la' then Result:='Latin' else
  if langcode='lb' then Result:='Luxembourgish' else
  if langcode='lg' then Result:='Ganda' else
  if langcode='li' then Result:='Limburgan' else
  if langcode='ln' then Result:='Lingala' else
  if langcode='lo' then Result:='Lao' else
  if langcode='lt' then Result:='Lithuanian' else
  if langcode='lu' then Result:='Luba-Katanga' else
  if langcode='lv' then Result:='Latvian' else
  if langcode='mg' then Result:='Malagasy' else
  if langcode='mh' then Result:='Marshallese' else
  if langcode='mi' then Result:='Maori' else
  if langcode='mk' then Result:='Macedonian' else
  if langcode='ml' then Result:='Malayalam' else
  if langcode='mn' then Result:='Mongolian' else
  if langcode='mo' then Result:='Moldavian' else
  if langcode='mr' then Result:='Marathi' else
  if langcode='ms' then Result:='Malay' else
  if langcode='mt' then Result:='Maltese' else
  if langcode='my' then Result:='Burmese' else
  if langcode='na' then Result:='Nauru' else
  if langcode='nb' then Result:='Norwegian Bokmaal' else
  if langcode='nd' then Result:='Ndebele, North' else
  if langcode='ne' then Result:='Nepali' else
  if langcode='ng' then Result:='Ndonga' else
  if langcode='nl' then Result:='Dutch' else
  if langcode='nl_BE' then Result:='Flemish' else
  if langcode='nn' then Result:='Norwegian Nynorsk' else
  if langcode='no' then Result:='Norwegian' else
  if langcode='nr' then Result:='Ndebele, South' else
  if langcode='nv' then Result:='Navajo' else
  if langcode='ny' then Result:='Chichewa' else
  if langcode='oc' then Result:='Occitan' else
  if langcode='oj' then Result:='Ojibwa' else
  if langcode='om' then Result:='Oromo' else
  if langcode='or' then Result:='Oriya' else
  if langcode='os' then Result:='Ossetian' else
  if langcode='pa' then Result:='Panjabi' else
  if langcode='pi' then Result:='Pali' else
  if langcode='pl' then Result:='Polish' else
  if langcode='ps' then Result:='Pushto' else
  if langcode='pt' then Result:='Portuguese' else
  if langcode='pt_BR' then Result:='Brazilian Portuguese' else
  if langcode='qu' then Result:='Quechua' else
  if langcode='rm' then Result:='Raeto-Romance' else
  if langcode='rn' then Result:='Rundi' else
  if langcode='ro' then Result:='Romanian' else
  if langcode='ru' then Result:='Russian' else
  if langcode='rw' then Result:='Kinyarwanda' else
  if langcode='sa' then Result:='Sanskrit' else
  if langcode='sc' then Result:='Sardinian' else
  if langcode='sd' then Result:='Sindhi' else
  if langcode='se' then Result:='Northern Sami' else
  if langcode='sg' then Result:='Sango' else
  if langcode='si' then Result:='Sinhalese' else
  if langcode='sk' then Result:='Slovak' else
  if langcode='sl' then Result:='Slovenian' else
  if langcode='sm' then Result:='Samoan' else
  if langcode='sn' then Result:='Shona' else
  if langcode='so' then Result:='Somali' else
  if langcode='sq' then Result:='Albanian' else
  if langcode='sr' then Result:='Serbian' else
  if langcode='ss' then Result:='Swati' else
  if langcode='st' then Result:='Sotho, Southern' else
  if langcode='su' then Result:='Sundanese' else
  if langcode='sv' then Result:='Swedish' else
  if langcode='sw' then Result:='Swahili' else
  if langcode='ta' then Result:='Tamil' else
  if langcode='te' then Result:='Telugu' else
  if langcode='tg' then Result:='Tajik' else
  if langcode='th' then Result:='Thai' else
  if langcode='ti' then Result:='Tigrinya' else
  if langcode='tk' then Result:='Turkmen' else
  if langcode='tl' then Result:='Tagalog' else
  if langcode='tn' then Result:='Tswana' else
  if langcode='to' then Result:='Tonga' else
  if langcode='tr' then Result:='Turkish' else
  if langcode='ts' then Result:='Tsonga' else
  if langcode='tt' then Result:='Tatar' else
  if langcode='tw' then Result:='Twi' else
  if langcode='ty' then Result:='Tahitian' else
  if langcode='ug' then Result:='Uighur' else
  if langcode='uk' then Result:='Ukrainian' else
  if langcode='ur' then Result:='Urdu' else
  if langcode='uz' then Result:='Uzbek' else
  if langcode='ve' then Result:='Venda' else
  if langcode='vi' then Result:='Vietnamese' else
  if langcode='vo' then Result:='Volapuk' else
  if langcode='wa' then Result:='Walloon' else
  if langcode='wo' then Result:='Wolof' else
  if langcode='xh' then Result:='Xhosa' else
  if langcode='yi' then Result:='Yiddish' else
  if langcode='yo' then Result:='Yoruba' else
  if langcode='za' then Result:='Zhuang' else
  if langcode='zh' then Result:='Chinese' else
  if langcode='zu' then Result:='Zulu' else
  Result:='';
end;

end.
