requires 'perl', '5.014';

requires 'App::optex', '0.03';
requires 'Text::VisualPrintf', '3.09';
requires 'Text::ANSI::Fold::Util', '0.02';

on 'test' => sub {
    requires 'Test::More', '0.98';
};

