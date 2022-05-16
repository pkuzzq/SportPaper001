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

# 鲍明晓 - 体育产业

体育活动，社交型赛事。服务领域的价值、技能培养，娱乐价值。
赞助少
财政拨款减少
公益彩票分成减少 20%；
赛会制，门票收入 -3000~4000
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

### 研究设计

- 数据：1993-2002 年 104 个村庄 6000 多个农村家庭，来源于农业部农业经济研究中心，包含农业活动的收入、支出、净收入和工资收入等信息
- 实证方法：固定效应模型、反事实实验？

### 发现

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
3. 两个部门的模型 + 反事实的实验 - 农业中在错配的影响对个人在农业非农业的职业选择

研究发现：
政策产生的土地产权和资本的破碎化对农业总生产力的影响通过两方面体现：1. 农民间资源分布的不均衡；2. 不同部门之间工人的分布尤其是农业部门中农民的职业选择。

意义：
1. 通过联系中国具体政策讨论资源错配和生产力
2. 扭曲政策的影响是通过选择技能扩大了错配
3. 实证主要验证了扭曲造成了农业中生产力低下

# Log：2022-05-05

任务是

- reading paper

- 《置身事内》摘要 + 与上课联想
  -  将省份在中国经济中的地位， 与球队在联盟中的合作与竞争的关系形成类比
  -  比如说超级明星效应中的勒布朗詹姆斯与 阿里巴巴在地方经济中的角色形成类比

- Data Collection
  - Deaton 1997
  - Glewwe and Grosh 2000 for survey data
  - Gerber and Green 2012
  - Glennerster and Takavarasha 2013 for randomized controlled trials

- Where the data come from, when they were collected, by whom, how the observations that compose the sample were chosen for inclusion (i.e., the survey methodology, or how regions, communities, households, individuals, etc. were all chosen), what population the sample is representative of, what the target sample size was and how that sample size was determined (e.g., via power calculations), what the actual sample size is, what the nonresponse rate was, what the attrition rate is in case the data are longitudinal, how missing data were dealt with (e.g., whether observations were simply dropped, or whether some values were imputed and, if so, how the imputation was done).【数据来自何处，何时收集，由谁收集，构成样本的观测数据是如何被选择的（即调查方法，或如何选择地区、社区、家庭、个人等），样本代表什么人群，目标样本量是多少，该样本量是如何确定的（例如，通过功率计算），实际样本量是多少，无应答率是多少，如果数据是纵向的，损耗率是多少。通过功率计算），实际的样本量是多少，非应答率是多少，如果数据是纵向的，损耗率是多少，如何处理缺失的数据（例如，观察值是否被简单地删除，或者是否对某些值进行了归类，如果是这样，如何进行归类）。】

在介绍了上述内容之后，现在是介绍和讨论描述性统计的时候了。
在感兴趣的变量（即治疗变量）由几个类别组成的情况下，显示平衡检验的结果 conditional on treatment status 已成为实际需要，即表格中的每一行都是为分析而保留的变量，其中的均值和标准误差是以治疗状态为条件的，并且通过报告均值差异检验的 P 值来评估每个变量的均值是否在不同治疗状态下存在系统性差异。虽然教科书上的例子涉及两个治疗状态 -- 治疗和控制 -- 但研究中包括两个以上的治疗组的情况越来越普遍，因此任何有意义的平衡检验都必须对每一对均值的比较进行重新报告。对于两个治疗组，这意味着（i）治疗 1 与对照组，（ii）治疗 2 与对照组，以及（iii）治疗 1 与治疗 2。

- RCT 的条件：在治疗组和对照组之间进行完全随机分配的情况下，应该有少于 1/10 的配对比较差异低于 10% 的统计显著性水平，少于 1/20 的配对比较差异低于 20% 的统计显著性水平，以及少于 1/100 的配对比较差异低于 1% 的统计显著性水平。

- 表格：除了通常的均值和标准差表以及一个或多个显示平衡测试结果的表格外，一个好的数据和描述性统计部分还可以用来探索**非参数化**的数据，显示相关变量的核心密度估计值（即，至少是结果和治疗变量，**如果它们是连续的，也可以是怀疑是治疗异质性来源的控制因素**）。如果是连续变量，则显示结果和治疗变量的**核心密度估计值**；如果是分类变量，则显示相关变量的**直方图**；如果治疗和结果都是**双项的，则显示交叉表**（即两两对照表）。

- 在撰写数据和描述性统计部分时，有几个重要的错误你应该避免。第一个错误是在写作中对平均值进行平淡的列举。如果性别变量只是作为分析中的一个**控制变量**，那么在文本中指出 "37.4% 的受访者是女性 "就没有什么用处了，因为读者可以自己去查；通常值得在这里讨论的唯一变量是**结果变量和处理变量**，任何用于识别的变量（例如，工具变量或强制变量），或者任何真正突出的变量。一般来说，一个好的经验法则是将描述性统计的讨论控制在几句话内。

- 第二个错误是在讨论数据和描述性统计时使用了过去式。上面的例子说 "37.4% 的受访者是女性"，而不是 "37.4% 的受访者是女性"。英语中的科学交流在使用现在时讨论自己的数据或结果时更有效，就像应该避免使用被动语态一样，除了总结和归纳时，也应该避免使用过去时。

# Log:2022-05-06

任务清单：

- 套路：陈硕（list）、Marc F. Bellemare
- 主题：毛付丰、Nicolas Watanabe
- DID stuff：theoretical exogeneity + statistical exogeneity
- Data：面板数据如何从数据库构建！哪些学者？如何做的？

## MHE P 1-36

-  处理观测性的数据要用实验性的思维在一个可能的世界里构建一个理想的实验
-  The mechanics of an ideal experiment highlight the forces you’d like to manipulate and the factors you’dlike to hold constant.

- FAQs v.s. FUQ'd
  - 1. What is the causal relationship of interest?
  - 2. the experiment that could ideally be used to capture the causal effect of interest.
  - 3. what is your identification strategy?
    - Angrist and Krueger (1999)used the term identification strategy to describe the manner in which a researcher uses observational data(i.e., data not generated by a randomized trial) to approximate a real experiment.
  - 4. Rubin (1991): what is your mode of statistical inference?
    - ![6xKd3g](https://pkuzzq-image.oss-cn-beijing.aliyuncs.com/uPic/6xKd3g.png)
    - 25/290

### chapter 1-2

  - To describe this problem more precisely, think about hospital treatment as described by a binary random variable, $\mathrm{D}_{i}=\{0,1\}$. The outcome of interest, a measure of health status, is denoted by $\mathrm{Y}_{i}$. The question is whether $\mathrm{Y}_{i}$ is affected by hospital care. To address this question, we assume we can imagine what might have happened to someone who went to the hospital if they had not gone and vice versa. Hence, for any individual there are two potential health variables:
  - $$\text { potential outcome }= \begin{cases}\mathrm{Y}_{1 i} & \text { if } \mathrm{D}_{i}=1 \\ \mathrm{Y}_{0 i} & \text { if } \mathrm{D}_{i}=0\end{cases}$$
  - A naive comparison of averages by hospitalization status tells us something about potential outcomes,though not necessarily what we want to know. The comparison of average health conditional on hospital-ization status is formally linked to the average causal e¤ect by the equation below:
  - $$\begin{aligned}\underbrace{E\left[\mathrm{Y}_{i} \mid \mathrm{D}_{i}=1\right]-E\left[\mathrm{Y}_{i} \mid \mathrm{D}_{i}=0\right]}_{\text {Observed difference in average health }} &=\underbrace{E\left[\mathrm{Y}_{1 i} \mid \mathrm{D}_{i}=1\right]-E\left[\mathrm{Y}_{0 i} \mid \mathrm{D}_{i}=1\right]}_{\text {average treatment effect on the treated }} \\&+\underbrace{E\left[\mathrm{Y}_{0 i} \mid \mathrm{D}_{i}=1\right]-E\left[\mathrm{Y}_{0 i} \mid \mathrm{D}_{i}=0\right]}_{\text {selection bias }}\end{aligned}$$
  - Because the sick are more likely than the healthy to seek treatment, thosewho were hospitalized have worse y0i’s, making selection bias negative in this example. The selection biasmay be so large (in absolute value) that it completely masks a positive treatment e¤ect.
  - The first question to ask about a randomized experiment is whether the randomization successfully balanced subject's characteristics across the different treatment groups.
  - 假设没有异质性的处置效应
  - $$\begin{aligned}&\mathrm{Y}_{i}=\alpha+\quad+\quad \rho \quad \mathrm{D}_{i}+\quad \eta_{i}\\&11 \quad 11\\&E\left(\mathrm{Y}_{0 i}\right) \quad\left(\mathrm{Y}_{1 i}-\mathrm{Y}_{0 i}\right) \quad \mathrm{Y}_{0 i}-E\left(\mathrm{Y}_{0 i}\right)\end{aligned}$$
  - Nevertheless, inclusion of the variables Xi may generate more precise estimates of the causal e¤ect ofinterest.
      - 效果 1：加入固定效应。像 Krueger（1999）中，加入学校固定效应后，回归系数变大且更显著了，当然牛逼！首先就要是稳健的！→ 这是为什么呢？？？？
      - 效果 1'：加入固定效应。处置效应的标准误减少了。因为学校的固定效应也解释了 Y 变量在干预组和控制组之间差会有很大差别的原因，因此标准误会减少。
      - 效果 2：加入好的控制变。标准误变小，更稳健。因为这些好的控制变量对 Y 有解释力，因此减少了残差的方程，从而减少了估计系数的标准误。
      - 效果 3：加入一个在两个组别都平衡掉的控制变量后，处置效应估计值及其标准误都没有变。

## 毛付丰 + 陈硕 + 体育健康经济的桥梁

  - 既然赛事对城市发展有促进作用。国内对一产有减少了；国际对二、三产都有显著促进。那么这种促进在城市层面上能够扩散到多远？
  - 疑问：did 和事件研究方法有什么区别？
  - 另一个目标：赛事对人民的健康有什么促进作用。
    - 建构面板数据 + 城市
      - 《2020- 毛丰付 - 重大体育赛事对城市经济发展的影响——基于中国 70 个大中城市面板数据分析。pdf》
      - 《2015. 毛丰付，姚剑锋。城镇化与 “胖中国” 收入，收入不平等与 BMI. 商业经济与管理。.pdf》

  - 健康经济的研究不仅追求实现有限医疗卫生资源的效益最大化，而且还追求提高群体人力资本，特别是实现群体人口健康状况从异质性向同质性的转化；其次，健康经济学的服务人群覆盖面广，包括了非健康人口群体和健康人口群体；再次，健康经济学研究所涉及的变量更为丰富，并且包含了大量的社会科学内容。
    - 健康作为人力资本内嵌于劳动力中 Petty1676、Fisher1909、Arrow1963、Grossman1973 健康需求理论（健康资本）、

# Log：2022-05-07

- MHE
- DID 网站

## MHE P 37-54

### chapter 3 让回归变得有意义

渐进 OLS 推断涉及到了 4 个性质：
1. **大数定律**：样本矩概率收敛于相应的总体矩。换句话说，通过抽取足够大的样本，或者抽取样本的次数足够多，样本平均值接近总体平均值的概率非常大。
2. **中心极限定理**：样本矩是渐进的正态分布的（表现形式为：其减去相应的总体距并乘以样本大小的平方根）。协方差矩阵是由对应的随机变量的方差给出的。换句话说，在足够大的样本中，归一化后的变量的样本矩是近似正态分布的。
3. **斯拉斯基定理**：
4. **连续映射定理**：
   斯拉茨基定理可算是连续映射定理的一个简单推论吧，也就两个变量相加、乘、除都是这两个变量的连续函数；连续映射定理基本上说的是只要随机变量以某种形式收敛，其连续函数也以同样的形式收敛。当然，从连续映射定理推论斯拉茨基定理还需要一个额外步骤，就是两组随机变量各自分别收敛的话，它们组成向量之后也一样收敛。前面说的“连续函数”是这个向量的连续函数。

似乎明白了渐进最小二乘推断为什么跟上面定理有关系

异方差修正标准 = 怀特标准误 = 稳健标准误；以及构造时的原理是什么，就是用构造四阶矩，矩阵

## 任务清单

- 《置身事内》摘要 + 与上课联想
- 套路：陈硕（list）、Marc F. Bellemare
- 主题：毛付丰、Nicolas Watanabe
- DID stuff：theoretical exogeneity + statistical exogeneity
- Data：面板数据如何从数据库构建！哪些学者？如何做的？

# Log：2022-05-10

- MHE
- DID 网站

## 任务清单

- 《置身事内》继续
- 套路：
  - 陈硕：一刀切 DID、渐进 DID
  - Marc F. Bellemare：
- 主题延伸：Nicolas Watanabe
- [DID stuff](https://asjadnaqvi.github.io/DiD/)
- Data 构建：面板数据如何从数据库构建！哪些学者？如何做的？ → 有模仿文章或者操作指南
- 目标文章 → 复制结果
- Cunningham
  - cd /Users/zhouzhengqing/Desktop/SportsEconAnalysis/++SC/Slides
  - open *02

Bacon decomposition
- https://asjadnaqvi.github.io/DiD/docs/code/06_bacon/
- https://www.lianxh.cn/news/122dffa5b6d39.html

## MHE P 54+ 暂放

# Log：2022-05-13 + 2022-05-14 +2022-05-15

## 任务清单

### 优先必须完成

— from code to data
  - Data 构建：面板数据如何从数据库构建！哪些学者？如何做的？ → 有模仿文章或者操作指南
    - 目标文章 → 复制结果
    - Cunningham + #codechella + [DID stuff](https://asjadnaqvi.github.io/DiD/)
        - cd /Users/zhouzhengqing/Desktop/SportsEconAnalysis/++SC/Slides
        - open *02

- 套路
  - 陈硕：一刀切 DID、渐进 DID
  - Marc F. Bellemare：

### 提前插队

- SEA 备课

### 可以暂放

- 《置身事内》继续

- from econ to sportecon
  - Nicolas Watanabe

## Note

### TWFW &DD: code + data

- 从TWFE → DD
- 简要回顾下TWFE估计值 
  - TWFE通过使用样本均值去将**个体内部的跨期的、不可观测的异质性**消除了，这里有一个前提是**消除的是不可观测的、不随时间变动(跨期相同)的异质性**
    - 所以TWFE中加入的是**时间固定效应、个体固定效应和个体与时间趋势的交叉效应**
  - 在没有协变量的情况下，估计2*2的DD，我们一般使用TWFE
    - Abadie(2005)给出了非参数的方法来估计DD，即**条件共同趋势假设成立**，我们就可以不使用TWFE估计DD了 → 直接用样本均值替代
  - 在DD框架下，他是每个单独的2*2cohort的加权平均
- 实际中，我们会在有协变量的情况下，使用OLS(TWFE)估计DD。
  - DD与TWFE比较:
    - **DD不需要再随机化，只需要平行趋势预测**
    - 干预是基于**可观察的协变量进行选择的** → 在DD中，我必须要控制X，才能保证treatment是成立的
    - TWFE中，当你控制基线的协变量X(认为它对日后的Y是有影响的)时候，它会被单位固定效应吸收 → 无法估计出来
      - 解决这个问题方法是加入**时变控制**，但这会限制DGP，Sant’Anna and Zhou（2020）中说明了原因
      - Abadie（2005）建议使用时间序列logit或线性概率模型估计的倾向得分对均值差分进行加权
    - DD中是在模型中加入时间的

![cc4tM9](https://pkuzzq-image.oss-cn-beijing.aliyuncs.com/uPic/cc4tM9.png)

- "三步法"估计DD → 具有异质性的ATT估计量，但是跨期相同，且适用于2*2案例
  - step1:计算每个单位的"post - pre"，即DD部分
  - step2:对每个单位使用倾向得分进行加权
  - step3:比较干预组的"post - pre"与控照组"post - pre"的加权差分
  - 在step2会有推断，这通常是粘性部分（Abadie 和 Imbens 匹配论文中不能使用Bootstrap进行匹配，但可以使用倾向得分匹配）




```参见 baker.do```
- baker 构建的 panel data：1000 个 unit（公司），分布在 40 个州，每个州 25 个 + 有四个政策组（经历不同时期的冲击）+ 最长时间跨度为 30 年
  - step1：create the states，40
  - step2：create firms → each state 生成 25 个公司 = 40*25
  - step3：create the years → each firm 有 30y，
  - step4：create id, egen id =group(state firms)
- 生成 cohort，每期多增加 250 个被干预的公司，the treatment effect still 7 on average
  - step1：create cohort → 按照 state 分成 4 个 cohort（其实就是 group），每个 cohort 的政策干预开始时间不同
    - 把 40 个州分成 4 个 cohort
    - 每个 cohort 会对应一个政策开始的年份
    - 用（0,1）在每个 cohort 中将政策从具体哪一年开始执行标识出来，标识出来后到代表**永久性的进入干预状态** → 这里的假设是"没有政策失效"
  - step2：create policy → 政策强度，对每个 cohort 是不同，时间开始越往后的 cohort 的强度越小
    - 分类：Basic DD + Staggered DD
      - Basic DD （不存在政策执行跨期 cohort)
        - 情形 1. constant T effect（政策效力跨期相同）
        - 情形 2. dynamic T effects（政策效力跨期不同，在 TWFE 中加入每期的时间的 dummy)
      - Staggered T DD （存在政策执行跨期 cohort)
        - 情形 1. 个体间相同的 constant T effects（政策效力跨期相同）: 若满足 trends 假设，VWCT=0 且 DeltaATT=0, 所有 TWFE 一致就是 VWATT（方差加权的任意 2*2ATT，这个 ATT 是政策效力跨期相同的）
        - 情形 2. 个体间相同的 dynamic T effects（政策效力跨期不同方式 1)：即使满足 trends 假设，VWCT=0 ，DeltaATT $≠$ 0 ,TWFE 有偏（该偏误仅存在于单一系数设定；在事件研究的设定，可以用 TWFE；在事件研究中，没有 NeverT 的话，也会 TWFE 也会有偏） → 一般也就从 TWFE 转型 StaggerDD 的方法了
        - 情形 3. 个体间不同的 dynamic T effects（政策效力跨期不同方式 2)：即使满足 trends 假设，VWCT=0 ，DeltaATT $≠$ 0 ,TWFE 有偏（足够坏会改变符号） → 就只能从 TWFE 转型 StaggerDD 的方法了
    - Baker 的假设是：每个 cohort 有不同强度的冲击，政策开始越晚的，政策强度越小 → **在 cohort 内是静态的政策冲击，cohort 间是异质性**
    - 对 Baker 的扩展：对于同一 cohort 内 (cohort 间是异质性），政策冲击是累积的，累积时间越久，政策效力越大 (cumulative treatment effect) → **Dynamic treatment effects over time for each group**
    - 这里 baker.do 给定的 STDD 的情形 1
    ```
    DGP: heterogeneous versus constant (but always across group heterogeneity)
    Cumulative treatment effect is te x (year - t_g + 1) -- Dynamic treatment effects over time for each group.
    How does (year - treat_date + 1) create dynamic ATT?  Assume treat_date is 1992 and it is year 2000.
    Then, te=8 x (2000 - 1992 + 1) = 8 x (9) = 72. Group 2's TE rises from an 8 up to 72 in the t+8 year.
    ```
  - step3：STDD情形1的Y的DGP,STDD情形2的Y的DGP

- 从TWFE → eventstudy & DD
  - TWFE：{individual level fixed effects(firm/person) + unit level fixed effects(state/province) + common timing trends(time dummy)}{unobserved} + {X_it(time_variant coviarates: edu_it) + Z_i(time_invariant coviarates: gender)}{observed}
  - cohort level ATT(unit with same year treated) → 这就是eventstudy的灵感来源 → 它是dynamic的 → 对应于Staggered T DD情形(3)，S&A(2020)解决了它，CS(2020)同样解决了它 
    - stata: id =group(state firms) → 将LSDV中的 i.id 意味着同时包含了 individual level & unit level 
    - cohort 是将unit按照不同的干预发生时间进一步分开。 treat_date = year_treated + unit 中的部分)
- eventstudy = TWFE(baseline model中有common time trends) + Leads&Lags
  - Leads&Lags base on the time → 将time按照分化成leads period indicator + lags period indicator
  - 其实是TWFE under differential timing
  - 建立一个bin dummy，将Leads&Lags中重新"block" 
  - 通过block，实现对cohort-specific ATT
  - SA将其分为
    - static specification
    - dynamic specificaiton
  - 由于多重共线性:一般会把-1drop，-4drop

- 共性问题是DD&TWFE
  - 假设1:parallel trend
  - 假设2：no anticipation(它是 SUTVA 的延伸，因为 SUTVA 要求您的结果是您当前治干预状态的函数，而不是未来治疗状态的函数)
    - 如果有质疑，把颁布政策的年份置换为文件呢公布政策要讨论的年份


# Log：2022-05-16

## 任务清单
- data + reduplicate 
  - local data
- topic + question + partner
### 优先必须完成
- from econ to sportecon
  - Nicolas Watanabe
  - Marc F. Bellemare
— from code to data
  - Data 构建：面板数据如何从数据库构建！哪些学者？如何做的？ → 有模仿文章或者操作指南
- 套路
  - 陈硕：一刀切 DID、渐进 DID

- topic + questions + paper_cited
### 提前插队
- 地板球备课
- SEA备课
### 可以暂放
- 《置身事内》继续



