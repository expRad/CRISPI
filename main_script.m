
clear all
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is a MATLAB script with example data & code of the gradient pre-emphasis 
% technique that uses the Gradient System Transfer Function (GSTF) for trajectory correction.
% This concept was applied to accelerated spiral cardiac real-time MRI (CRISPI) as
% submitted to MRM in May 2020.

% The figure that is generated by this script compares the nominal and pre_emphasized
% gradient waveforms.

% Corresponding author: 
% Philipp Eirich, University Hospital Wuerzburg, Germany
% Contact: Eirich_P@ukw.de
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

N1 = 4096; % Sample size used for the FTed gradient array, efficient when N1 = 2^n

%% example spiral gradient waveform
gradient = [0,0,0,0,1.900094381e-08,0.002121660513,0.01656676277,0.04950791467,0.09007228608,0.1232645751,0.1480356875,0.1642732823,0.171429355,0.1694263223,0.1586580045,0.139896675,0.1141868355,0.08274418076,0.04686862365,0.007874888908,-0.03295943671,-0.07443054778,-0.1154326867,-0.1549729399,-0.192179054,-0.226302231,-0.256716366,-0.2829147909,-0.3045052801,-0.321203864,-0.3328278375,-0.3392882495,-0.3405820835,-0.3367842892,-0.3280397881,-0.3145555489,-0.2965928092,-0.2744595049,-0.2485029557,-0.2191028461,-0.1866645346,-0.1516127129,-0.1143854373,-0.07542854285,-0.03519045195,0.005882618687,0.04735104982,0.08878581164,0.1297720597,0.1699123405,0.2088294162,0.2461687162,0.2816004305,0.3148212544,0.3455558021,0.3735577014,0.3986103884,0.4205276156,0.4391536941,0.4543634841,0.4660621539,0.4741847231,0.4786954098,0.4795867974,0.4768788403,0.4706177238,0.460874597,0.4477441931,0.4313433542,0.411809476,0.389298886,0.3639851708,0.3360574649,0.3057187143,0.2731839276,0.2386784241,0.2024360924,0.1646976671,0.125709034,0.08571957213,0.04498054047,0.003743516383,-0.03774110793,-0.079225565,-0.1204660829,-0.1612241825,-0.2012678984,-0.2403729186,-0.2783236427,-0.3149141542,-0.3499491081,-0.38324453,-0.4146285288,-0.4439419217,-0.4710387717,-0.4957868404,-0.5180679543,-0.5377782893,-0.5548285729,-0.5691442084,-0.580665322,-0.5893467359,-0.5951578715,-0.5980825841,-0.598118934,-0.5952788964,-0.5895880144,-0.5810849984,-0.569821276,-0.5558604954,-0.5392779881,-0.5201601924,-0.4986040429,-0.4747163306,-0.4486130355,-0.4204186371,-0.3902654063,-0.3582926816,-0.3246461342,-0.2894770243,-0.252941454,-0.2151996174,-0.1764150534,-0.1367539027,-0.09638417308,-0.05547501473,-0.01419600857,0.02728352972,0.06879522793,0.1101723156,0.1512502603,0.1918673803,0.2318654316,0.2710901678,0.3093918723,0.3466258599,0.3826529492,0.417339902,0.4505598312,0.4821925765,0.512125045,0.5402515202,0.5664739356,0.5907021151,0.6128539794,0.6328557189,0.6506419329,0.6661557363,0.6793488332,0.6901815594,0.6986228931,0.7046504356,0.7082503622,0.7094173449,0.7081544474,0.7044729931,0.6983924087,0.6899400423,0.67915096,0.6660677196,0.6507401242,0.6332249569,0.6135856979,0.5918922242,0.5682204953,0.5426522252,0.5152745414,0.4861796334,0.4554643922,0.4232300409,0.3895817589,0.3546283008,0.3184816105,0.2812564338,0.2430699277,0.2040412713,0.1642912754,0.1239419965,0.0831163518,0.04193774023,0.0005296673874,-0.0409846223,-0.0824825066,-0.1238423382,-0.1649437886,-0.2056681816,-0.2458988173,-0.2855212837,-0.324423757,-0.3624972888,-0.3996360815,-0.4357377479,-0.4707035593,-0.5044386771,-0.5368523706,-0.5678582195,-0.5973743016,-0.6253233635,-0.6516329777,-0.676235682,-0.6990691043,-0.7200760714,-0.7392047012,-0.7564084801,-0.7716463246,-0.7848826269,-0.7960872858,-0.8052357224,-0.812308881,-0.8172932156,-0.8201806618,-0.820968596,-0.8196597799,-0.8162622927,-0.8107894508,-0.8032597151,-0.7936965869,-0.7821284925,-0.768588657,-0.7531149686,-0.7357498328,-0.7165400179,-0.6955364916,-0.6727942505,-0.6483721415,-0.622332677,-0.5947418437,-0.5656689062,-0.5351862052,-0.5033689513,-0.4702950157,-0.4360447169,-0.4007006053,-0.3643472449,-0.3270709949,-0.2889597889,-0.2501029144,-0.2105907924,-0.1705147573,-0.1299668383,-0.08903954197,-0.04782563732,-0.006417943148,0.03509088151,0.07660854356,0.1180433182,0.159304247,0.2003013314,0.2409457216,0.2811498995,0.3208278565,0.3598952656,0.3982696466,0.4358705256,0.4726195877,0.5084408222,0.5432606616,0.5770081126,0.6096148804,0.6410154847,0.6711473683,0.6999509984,0.7273699592,0.7533510373,0.7778442987,0.8008031581,0.8221844397,0.841948431,0.8600589274,0.8764832701,0.891192375,0.9041607547,0.9153665324,0.9247914483,0.9324208585,0.9382437266,0.9422526082,0.9444436278,0.9448164498,0.9433742421,0.940123633,0.9350746625,0.9282407272,0.9196385186,0.9092879571,0.8972121194,0.8834371609,0.8679922338,0.8509093996,0.8322235373,0.8119722481,0.7901957551,0.7669368002,0.7422405364,0.7161544184,0.6887280891,0.6600132635,0.630063611,0.598934635,0.5666835501,0.5333691587,0.4990517256,0.4637928516,0.427655346,0.3907030989,0.3530009525,0.3146145731,0.2756103219,0.2360551275,0.1960163573,0.1555616913,0.1347988651,0.1140360389,0.09327321262,0.07251038638,0.05174756014,0.03098473391,0.01022190767,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];

numExtraSamples = (N1 - length(gradient))/2; % Zero filling for further processing
gradient_long = [gradient(1)*ones(1,numExtraSamples) gradient() gradient(end)*ones(1,numExtraSamples)]; 

gradient_pre_long = pre_emphasis(gradient_long.'); % Here the pre_emphasis function is called

gradient_pre(:) = gradient_pre_long(numExtraSamples+1:numExtraSamples+length(gradient));    

%%%%%%%%%%%%%%%%%%%%%%%%%%%

FONT = 20;
LINE = 3;

x_nom = (1:length(gradient))*10e-3;
Gradient_Amplitude = 36; %[mT/m]

figure('Position',[50 50 1000 700]);
hold on
plot(x_nom,gradient*Gradient_Amplitude,'k-','Linewidth',LINE)
plot(x_nom,gradient_pre*Gradient_Amplitude,'b-','Linewidth',LINE)
legend('nominal','pre-emphasized')
set(gca,'FontSize',FONT)
xlabel('t [ms]')
ylabel('g(t) [mT/m]')
legend('boxoff')
legend('Orientation','horizontal')
hold off
    








