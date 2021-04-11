grammar StatesML;

// Parser

document: EOL* machine_definition EOL* EOF;

machine_definition: Machine machine_identifier machine_block;
machine_block: OpenBrace EOL+ (machine_block_statement EOL+)* CloseBrace;
machine_block_statement
    : initial_definition
    | state_definition
    | parallel_definition
    | final_definition;

state_definition: State state_identifier state_block?;
state_block: OpenBrace EOL+ (state_block_statement EOL+)* CloseBrace;
state_block_statement
    : initial_definition
    | entry_definition
    | exit_definition
    | always_definition
    | transition_definition
    | state_definition
    | parallel_definition
    | final_definition
    | history_definition
    | invoke_definition
    | on_done_definition;

parallel_definition: Parallel state_identifier parallel_block?;
parallel_block: OpenBrace EOL+ (parallel_block_statement EOL+)* CloseBrace;
parallel_block_statement
    : entry_definition
    | exit_definition
    | always_definition
    | transition_definition
    | state_definition
    | parallel_definition
    | history_definition
    | invoke_definition
    | on_done_definition;

final_definition: Final state_identifier final_block?;
final_block: OpenBrace EOL+ (final_block_statement EOL+)* CloseBrace;
final_block_statement
    : entry_definition
    | exit_definition
    | return_definition;

history_definition: history_type? History state_identifier history_block?;
history_type: Deep | Shallow;
history_block: OpenBrace EOL+ (default_definition EOL+)* CloseBrace;

initial_definition: Initial transition_clause? action_block?;

default_definition: Default transition_clause? action_block?;

entry_definition: Entry action_block;

exit_definition: Exit action_block;

always_definition: Always re_enterable_transition_clause? transition_condition? action_block?;

transition_definition: On event_descriptors re_enterable_transition_clause? transition_condition? action_block?;
event_descriptors: event_descriptor (Comma event_descriptor)*;

invoke_definition: Invoke service_reference invoke_block?;
invoke_block: OpenBrace EOL+ (invoke_block_statement EOL+)* CloseBrace;
invoke_block_statement
    : on_done_definition 
    | on_error_definition 
    | return_definition
    ;

on_done_definition: OnDone re_enterable_transition_clause? transition_condition? action_block?;
on_error_definition: OnError re_enterable_transition_clause? transition_condition? action_block?;

return_definition: Return result_reference;

action_block: OpenBrace EOL+ (action_reference EOL+)* CloseBrace;

transition_clause: normal_transition_type transition_target;
re_enterable_transition_clause: transition_type transition_target;

transition_type: normal_transition_type | re_enter_transition_type;

transition_target: state_identifier (Comma state_identifier)*;
transition_condition: If condition_reference;

normal_transition_type: RightArrow;
re_enter_transition_type: ReEnter;

action_reference: external_reference;
condition_reference: external_reference;
result_reference: external_reference;
service_reference: external_reference;

external_reference: identifier OpenParen CloseParen;

machine_identifier: identifier;
state_identifier: identifier;

identifier: keyword | Identifier;
event_name: identifier | EventName;
event_descriptor: event_name | WildcardEventDescriptor;

keyword
    : Machine
    | State
    | Parallel
    | Final
    | History
    | Deep
    | Shallow
    | Entry
    | Exit
    | On
    | Always
    | If
    | Initial
    | Default
    | Invoke
    | OnDone
    | OnError
    | Return
    ;

// Lexer

OpenParen: '(';
CloseParen: ')';
OpenBrace: '{';
CloseBrace: '}';
Comma: ',';

RightArrow
    : '->' 
    | '→'
    ;
ReEnter
    : 're-enter' 
    | '⟳'
    ;

Machine: 'machine';
State: 'state';
Parallel: 'parallel';
Final: 'final';
History: 'history';
Deep: 'deep';
Shallow: 'shallow';
Entry: 'entry';
Exit: 'exit';
On: 'on';
Always: 'always';
If: 'if';
Initial: 'initial';
Default: 'default';
Invoke: 'invoke';
OnDone: 'onDone';
OnError: 'onError';
Return: 'return';

fragment IdStart: [\p{XID_Start}];

fragment IdContinue
    : [\p{XID_Continue}]
    | '-'
    | '.'
    ;

Identifier: IdStart IdContinue*;

fragment EventNameContinue
    : IdContinue 
    | ':'
    ;

EventName: IdStart (EventNameContinue+);

WildcardEventDescriptor
    : '*' 
    | IdStart EventNameContinue* '.*'
    ;

DocBlockComment: '/**' .*? '*/' -> channel(HIDDEN);
DocLineComment: '///' ~[\r\n]* -> channel(HIDDEN);

BlockComment: '/*' .*? '*/' -> channel(HIDDEN);
LineComment: '//' ~[\r\n]* -> channel(HIDDEN);

EOL
    : '\r'
    | '\n'
    | '\r\n';
WS: [ \t\u0000\u000B\u000C]+ -> skip;
