
# 2022-05-04
## ITS

中断时间序列（ITS）设计是针对时间序列的结果变量，通过检验干预前后斜率改变量和干预点即刻水平改变量，对干预措施的有效性进行评价的设计方法。ITS 的特点是在有效地控制干预前已存在的上升或下降趋势后，更准确地估计干预效应。本文以某综合医院专家挂号费减半对门诊量影响为例，阐述单组 ITS 的设计原理和统计方法，使用分段线性回归拟合模型，并对结果进行解释。同时，阐述先后存在两种干预的效果评价 ITS 模型和干预后不同时间点效果评价 ITS 模型的设计原理、模型拟合方法和结果解释。公共卫生监测数据大多都有时间趋势，为了准确估计干预措施的有效性，需要考虑干预前序列已经存在的上升或下降趋势。ITS 通过斜率改变量和即刻水平改变量两个指标评价干预效果，丰富了传统的干预评价模式，在干预效果评价中必有广泛的应用。

http://rs.yiigle.com/CN112150201908/1156124.htm

## CITS

本文荟萃分析了 12 项异质研究，这些研究检查了比较中断时间序列设计 (CITS) 中的偏差，CITS 通常用于评估社会政策干预的效果。为了测量偏倚，每个 CITS 影响估计值都不同于从理论上无偏的因果基准研究得出的估计值，该研究用相同的治疗组、结果数据和估计值测试了相同的假设。在 10 项研究中，基准是随机实验，而在另外两项中，基准是回归 - 不连续性研究。分析显示平均标准化 CITS 偏差在 -0.01 和 0.042 标准差之间；除一项研究外，所有偏倚估计均落在其基准的 0.10 个标准差内，表明接近零均值偏差不是由许多大的单一研究差异平均造成的。个体偏倚估计的低均值和普遍紧密分布表明 CITS 研究值得推荐用于未来的因果假设检验，因为：（1）在所检查的研究中，它们通常导致较高的内部效度；(2) 它们还承诺具有很高的外部效度，因为我们综合的经验测试发生在各种环境、时间、干预和结果中。

## 可忽略性假设

这节采用和前面相同的记号。D 表示处理变量（1 是处理，0 是对照），Y 表示结果，X 表示处理前的协变量。在完全随机化试验中，可忽略性 D⊥{Y(1),Y(0)} 成立，这保证了平均因果作用 ATE(D→Y)=E{Y(1)–Y(0)}=E{Y∣D=1}–E{Y∣D=0} 可以表示成观测数据的函数，因此可以识别。在某些试验中，我们 “先验的” 知道某些变量与结果强相关，因此要在试验中控制他们，以减少试验的方差。在一般的有区组（blocking）的随机化试验中，更一般的可忽略性 D⊥{Y(1),Y(0)}|X 成立，因为只有在给定协变量 X 后，处理的分配机制才是完全随机化的。

## Sequential Ignorability

Necessary identification assumption: Sequential Ignorability (Imai, Keele, Yamamoto, 2010)

$$\begin{gathered}
\left\{Y_{i}\left(t^{\prime}, m\right), M_{i}(t)\right\} \perp T_{i} \mid X_{i}=x \\
Y_{i}\left(t^{\prime}, m\right) \perp M_{i}(t) \mid T_{i}=t, X_{i}=x
\end{gathered}$$

- Untestable
- Must defend your specification

如何诊断与解决多时点 DID 中的偏误？Baker et al.（2021）介绍了多种方法，包括 Goodman-Bacon 诊断法、蕴含重新赋权思想的 Callaway and Sant’Anna 估计量、堆栈回归（Stacked regression）等，并在最后给学者们提供了 8 条关于采用多时点 DID 的建议。限于篇幅，本文不再展开介绍。但值得一提的是，de Chaisemartin and D’Haultfoeuille（AER 2020）开发的 STATA 命令包“did_multiplegt”，以及 Callaway and Sant’Anna（2020）开发的 R 命令包“did”，都为实证研究学者解决该问题提供了便捷路径。

## DID 研究启动

李刚。中国企业赞助国内大型体育赛事的绩效研究一一基于事件研究法 [J]. 体育科学，2014,34(08)：22-33.
朱启莹，黄海燕。体育产业政策对体育类上市公司资本市场价值的短期影响 [J]. 上海体育学院学报，2016,40(6)：1-7
孔莹晖，贺灿飞，林初升 . 重大事件对城市投融资的影响研究：基于中国城市面板数据的实证分析［J］. 北京大学学报（自然科学版），2018，54（2）：451-458

感兴趣的变量

## Bartik instruments

Bartik T J.Who benefits from state and local economic development policies?Kalamazoo,MI:WE UpjohnInstitute for Employment Research[M].1991.-PDF-
Goldsmith-Pinkham P,Sorkin I,Swift H.Bartik instruments:What,when,why,and how[J].American EconomicReview,2020,110(8):2586-2624.-PDF-
·Acemoglu D,Autor D,Dorn D,etal.Import competition and the great US employment sag of the2ooOs[J].Journal of Labor Economics,2016,34(S1):S141-S198.-PDF-
·赵奎，后青松，李巍。省会城市经济发展的溢出效应一一基于工业企业数据的分析】. 经济研究，2021,56(03)：150-166.

## MOST IMPORTANT ADVICE:

### Structure of Introduction (in order):
1) Motivation (1 paragraph)
Must be about the economics.
NEVER start with literature or new technique (unless econometrics).
Be specific and motivate YOUR research question.

2) Research question (1 paragraph)

Lead with YOUR question.
THEN set YOUR question within most relevant literature.
My favorite is an actual question: “My paper answers the question …”
Popular and acceptable: “My paper [studies/quantifies/evaluates/etc] …”

3) Main contribution (2-3 paragraphs, one for each contribution)

YOUR main contribution:
MUST be about new economic knowledge.
Lead with YOUR work, then how it extends the literature.
New model, new data, new method, etc.:
Can be second or third contribution.
Tools are important, not most important.
Each paragraph begins with a sentence stating one of YOUR contributions.
THEN follow with three or four sentences setting YOUR contribution in literature.
Most important should be first (preferred) or last (sometimes most logical).
YOUR contributions are very important. Make them clear, compelling, and correct.

4) Method (1-2 paragraphs, one for each method)

Each paragraph begins with a sentence or two summarizing one of YOUR methods.
Lead with YOUR most important model, identification, or empirical method.
THEN follow with a few sentences that sets YOUR method in literature.
Save technical points, model assumptions for the model section.

5) Findings (2 to 3 paragraphs, one for each main finding)

Each paragraph begins with a sentence or two summarizing one of YOUR findings.
Most important should be first (preferred) or last (sometimes most logical).
THEN follow with three or four sentences setting YOUR finding in literature.
YOUR findings are very important. Make them clear, compelling, and correct.

5) Robustness Check  (optional 1 paragraph)

Choose robustness check that best supports YOUR most important finding.

6) Roadmap of paper (1 paragraph)

One sentence for each section of YOUR paper.
Be specific to YOUR paper, if possible.
PS My structure is NOT only structure that works well. See other excellent writing advice here. Your chair may disagree. LISTEN to people who decide on your PhD. Look at best papers in general-interest journals from best researchers in your field. Innovate on economics, not on structure of YOUR paper.

PPS set YOUR research in context of prior research. We stand on the shoulders of giants. Even so, do NOT bury YOUR contribution after two sentences (or two paragraphs, yikes!) on others’ contribution. Do not share YOUR research in the order you did it.

### Structure of Abstract (in order):

ALSO VERY IMPORTANT PART OF YOUR PAPER

Write AFTER you are happy with YOUR introduction.
Same structure as introduction, but sentences not paragraphs.
Use main points from YOUR introduction. Focus on YOUR work
Did YOU see a pattern? Yes, YOUR job market paper is about YOU!

 

### Tables and Charts

Font size must not cause eye strain.
ABSOLUTELY NO acronyms ANYWHERE in tables and charts.
ABSOLUTELY NO equation symbols or variables names without WORDS too.
Must convey takeaway within 10 seconds, without main text.
Try to make charts for YOUR main findings. Here are examples.
Label EVERY axis. Label EVERY column header.
Use as few decimal places as possible.
Must be clear what line goes with what label, including when print black and white.
 

## Other Random Economist Tips (not in any order):

Your paper is ALWAYS about YOUR work. Lead with YOU and then others.
Get feedback on YOUR abstract and introduction:
Ask classmate (different field)
Professor (in addition to chair)
Follow-up nicely until they do.
Let READER decide what is “important,” “obvious,” “surprising,” etc.
Do NOT annoy reader by being grandiose. NO bait and switch.
NO causal words for NON-causal estimates.
NO shame in non-causal results. We can’t run experiments (thank goodness) for many questions in economics. Solid empirical work MATTERS.
Do NOT trash prior research or call out its limitations or mistakes. TONE matters. Tell us what YOUR paper ADDS. They added too or you wouldn’t cite them.
Do NOT have stand-alone literature review section (unless adviser demands).
Integrate literature throughout your paper to set YOUR work in context.
Describe YOUR contributions, methods, and results before related literature.
NO acronyms.
 MPC is widely known in economics. I still use “spending propensity” or “spent $0.X0 out of every additional dollar within two weeks of receipt.”
ABSOLUTELY NO acronyms for terms:
YOU create. (Avoid creating new terms.)
Terms created in last 25 years.
NO economic jargon in introduction and abstract until explain in people words.
Know people words for economic jargon that YOU use.
MUST explain what is source of  “endogenous,” or “endogeneity”.
Use jargon (and use it correctly) in the body of the paper.
Show that YOU know YOUR technical stuff.
Still useful to explain most important point in generalist economist words.
Macro folks be careful here, we are less beloved.
Latex folks: Do NOT embed hyperlinks to your references.
Many read from PDF. Annoying to accidentally click and land far away.
Do NOT annoy reader and do NOT waste their time.
Who cares when the old farts got finally their paper published? Obsessed will simply check references for their name.
If you (still) want these links, make back buttons. Tips here, here, and here.
Cite papers most related to YOUR paper. YOU are not writing a survey.
Use standard citations in text: (Author-Name, Paper-Year).
Cite most recent version of papers.
Check results YOU cite remain in their latest version.
Make sure YOUR tone is NEUTRAL and stick to the facts.
Use “my paper” not “this paper.” After citing others, “this” is ambiguous.
Save policy implications for conclusion.
 

### Other Random Anyone Tips:

Say what YOU need to say and no more. Delete extra sentences.
Keep sentences short. Make one point.
Break long sentences or ones with more than one point in multiple sentences.
Avoid “There are/is.” Re-write and shorten sentence. For example, change “There are problems.” to “Problems exist.”
Be sparing with adverbs and adjectives.
Avoid clauses at beginning of sentence. Start “my paper” “I model” “I find.”
NO acronyms. Acronyms exclude new people.
Read first sentence of every paragraph. Together they should tell YOUR paper.
 

All the best on the job market!!

# 鲍明晓 -体育产业

体育活动，社交型赛事。服务领域的价值、技能培养，娱乐价值。
赞助少
财政拨款减少
公益彩票分成减少 20%；
赛会制，门票收入-3000~4000
上海市依靠国企；
消费手段：增加支付能力，政府购买，消费劵
提升消费技能：学校体育中技能，身体的手段多，教技能的手段少
群众体育最重要的项目化。社会体育指导员要项目化改革
体育经营场所。运动特色小镇，刚需和高频。
社区体育空间活动站缺失。成都的步道体系。开放
运动场景的建设。社交价值、心理维度。全数据

## 研究问题 - 陈硕

- X: 农业生产要素错配
- Y: 农业全要素生产率 TFP
### Motivation

- 不同国家农业生产率存在很大的差异，这是经济增长与发展的重要问题
- 贫穷国家的劳动力大多配置于农业部门，因此解释能也生产量率差异可以有助于对国家收入差异的理解
- 不同技能家庭的资源错配在发展中国家普遍存在
- 制度和政策带来的资源错配可以解释国家间生产效率差异的很大一部分

  文章讨论的是经济增长和发展差异的大话题，具体而言希望考察农业劳动生产率的差异，因为这对解释发展中国家收入具有重要意义。发展中国家普遍存在制度和政策导致的生产要素错配，从而解释了劳动生产率的差异。因此，文章考察了要素错配如何影响农业劳动生产率 TFP。

### 研究设计（实证或计量方法）

- 数据：1993-2002 年 104 个村庄 6000 多个农村家庭，来源于农业部农业经济研究中心，包含农业活动的收入、支出、净收入和工资收入等信息
- 实证方法：固定效应模型、反事实实验？

## 发现
- 由于土地无法合理配置（无法交易或出租，官员也无法根据农耕技术分配土地），导致中国农业劳动生产要素存在巨大的错配。
- 高技能和低技能的农民间存在错配
- 劳动力在农业部门或其他部门工作间存在错配
- 劳动力在部门间的错配大大加剧了生产率损失

### Implication
- 文章指出要素错配是由于制度导致的
- 文章扩展了对于要素错配影响的研究，发现跨部门的劳动力错配会进一步加剧对生产效率的影响
- 现实意义而言，发展中国家通过改变导致要素错配的制度有利于促进农业生产率提升

## 研究问题

资源错配（x1）和工作选择（x2）对生产力的影响 (y)
资源错配本文指的是政策规定土地产权后导致的农业土地和资本的分布有问题
工作选择本文指的是在市场的驱动下，加大了这种错配

Motivation：发展中国家和发达国家之间在农业部门的发展之间是有区别的，生产力的区别和资源错配有关，这又关乎农民内部的差异性。政策规定和市场放大下，两边是怎样的，还有待研究。

研究设计：
三个方面：1. 固定效应：农场级别生产力差异、村庄层面的扭曲差异和时间的差异 – 有多大程度的错配
2. 现代宏观经济学的诊断工具 – 边际生产和无效率的总体程度的差异
3. 两个部门的模型+反事实的实验- 农业中在错配的影响对个人在农业非农业的职业选择

研究发现：
政策产生的土地产权和资本的破碎化对农业总生产力的影响通过两方面体现：1. 农民间资源分布的不均衡；2. 不同部门之间工人的分布尤其是农业部门中农民的职业选择。

意义：
1. 通过联系中国具体政策讨论资源错配和生产力
2. 扭曲政策的影响是通过选择技能扩大了错配
3. 实证主要验证了扭曲造成了农业中生产力低下

# 2022-05-05

任务是

- reading paper

- 《置身事内》摘要 + 与上课联想
  -  将省份在中国经济中的地位， 与球队在联盟中的合作与竞争的关系形成类比
  -  比如说超级明星效应中的勒布朗詹姆斯与 阿里巴巴在地方经济中的角色形成类比