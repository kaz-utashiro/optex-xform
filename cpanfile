requires 'perl', '5.014';

requires 'App::optex', 'v0.4';
requires 'Text::VisualPrintf', '3.10';
requires 'Text::ANSI::Fold::Util', '0.02';

on 'test' => sub {
    requires 'Test::More', '0.98';
};

