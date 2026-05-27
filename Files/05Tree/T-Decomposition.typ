#import "../../template.typ": *

== Heavy-Light Decomposition
=== Concept
Heavy-Light Decomposition (HLD) is a special technique for trees. Through
preprocessing, it reduces the time complexity of range maximum, range minimum,
and range sum queries to $O \( log^2 \( n \) \)$, which is much faster than
the naive $O \( n \)$ approach.

First, root the tree as usual, then run one DFS to determine the subtree size
of every node.

In HLD, we always extend the chain by connecting to the child with the largest
subtree, which is called a heavy edge. All other edges are called light edges.
This guarantees that the number of chains does not exceed $O \( log \( n \) \)$.

#figure(image("../Images/HLD.png"),
  caption: [
    Heavy-Light Decomposition diagram
  ]
)

=== Implementation
The implementation requires several arrays.

#code(title: [Heavy-Light Decomposition with Segment Tree])[
  ```cpp
using ll=long long;
const int N=100010;
const ll INF=0x3f3f3f3f3f3f3f3f;
using pii=pair<int,int>;

int sz[N],fa[N],to[N],fr[N],dep[N],dfn[N];
// sz[x]  = subtree size of x
// fa[x]  = parent node of x
// to[x]  = the child of x with the largest subtree
// dep[x] = distance from x to the root
// dfn[x] = timestamp assigned when dfs visits x
// fr[x]  = the head of the chain containing x

int n;
vector<int> g[N];

void dfs(int x,int p){
    sz[x]=1, fa[x]=p, to[x]=-1;
    dep[x]=(p!=-1) ? dep[p]+1 : 0;

    for(auto u:g[x]) if(u!=p){
        dfs(u,x);
        sz[x]+=sz[u];
        if(to[x]==-1 || sz[u]>sz[to[x]])
            to[x]=u;
    }
}

void link(int x,int f){
    // time stamp
    static int tk=1;
    fr[x]=f;
    dfn[x]=tk++;// dfn[x]=tk, tk++;
    // extend the chain
    if(to[x]!=-1) link(to[x],f);

    for(auto u:g[x]){
        if(u==fa[x] || u==to[x]) continue;
        link(u,u);
    }
}

vector<pii> QueryPath(int u,int v){
    // return the intervals on the path from u to v
    int fu=fr[u],fv=fr[v];
    vector<pii> ret;
    while(fu!=fv){
        if(dep[fu]<dep[fv])
            swap(fu,fv), swap(u,v);
        ret.emplace_back(dfn[fu],dfn[u]);
        u=fa[fu];
        fu=fr[u];
    }
    if(dep[u]>dep[v]) swap(u,v);
    // now u is LCA
    ret.emplace_back(dfn[u],dfn[v]);
    return ret;
}

struct Seg{
    struct node{
        ll val,tag;

        node *rch,*lch;

        node(){
            val=tag=0;
            rch=lch=nullptr;
        }

        node(ll v){
            val=v, tag=0;
            rch=lch=nullptr;
        }

        void push(int l,int r){
            int len=r-l+1>>1;
            if(lch){
                lch->val+=tag*len;
                lch->tag+=tag;
            }

            if(rch){
                rch->val+=tag*len;
                rch->tag+=tag;
            }
            tag=0;
        }

        void pull(){
            val=0;
            if(lch) val+=lch->val;
            if(rch) val+=rch->val;
        }

        void modify(int p,ll v,int lb=1,int rb=n){
            if(lb==rb){
                val=v;
                return;
            }

            if(!lch) lch=new node();
            if(!rch) rch=new node();

            push(lb,rb);

            int mid=lb+rb>>1;

            if(p<=mid) lch->modify(p,v, lb ,mid);
            if(mid<p)  rch->modify(p,v,mid+1,rb);

            pull();
        }

        ll query(int l,int r,int lb=1,int rb=n){
            if(l<=lb && rb<=r){
                return val;
            }

            push(lb,rb);

            int mid=lb+rb>>1;

            ll ret=0;
            if(lch && l<=mid) ret+=lch->query(l,r, lb ,mid);
            if(rch && mid<r)  ret+=rch->query(l,r,mid+1,rb);

            pull();

            return ret;
        }

        void add(int l,int r,ll v,int lb=1,int rb=n){
            if(l<=lb && rb<=r){
                val+=v*(rb-lb+1);
                tag+=v;
                return;
            }

            push(lb,rb);

            int mid=lb+rb>>1;

            int ret=0;
            if(lch && l<=mid) lch->add(l,r,v, lb ,mid);
            if(rch && mid<r)  rch->add(l,r,v,mid+1,rb);

            pull();
        }
    };

    node *rt=new node();//root

    void modify(int p,int v){
        rt->modify(p,v);
    }

    ll query(int l,int r){
        return rt->query(l,r);
    }

    void add(int l,int r,ll v){
        rt->add(l,r,v);
    }
};

Seg seg;

void modify(int v,int p){
    p=dfn[p];
    seg.modify(v,p);
}

ll query(int u,int v){
    vector<pii> pt=QueryPath(u,v);
    ll ret=0;
    for(auto p:pt){
        ret+=seg.query(p.first,p.second);
    }
    return ret;
}

ll add(int u,int v,ll k){
    vector<pii> pt=QueryPath(u,v);
    for(auto p:pt){
        seg.add(p.first,p.second,k);
    }
}
  ```
]

=== Examples and Exercises
==== Problem: 1st Excellence Cup G. Safe Tariff (Hard)
*Problem Statement*

There are $n$ island nations in the Pacific Ocean, conveniently named $1$
through $n$. These island nations all use a common currency called the
International Silver Coin. There is a great deal of trade between these
nations, one type of which is gold brick shipping. There are a number of fixed
shipping routes between these nations, which are the primary means of exchange
and trade. Each route connects exactly two nations in both directions. If a
route connects nation $u$ and nation $v$, it is denoted $\( u \, v \)$ or
$\( v \, u \)$ — both representations are equivalent, meaning nations $u$ and
$v$ can trade directly. If nations $u$ and $v$ have no direct route, they may
still trade through multiple routes. If there exists a series of routes
$\( u \, p_1 \) \, \( p_1 \, p_2 \) . . . \( p_r \, v \)$, then nations $u$
and $v$ can trade; otherwise they cannot.

To protect the Pacific ecosystem, all nations agree to maintain as few routes
as possible while still allowing trade between any two island nations. It is
clear that $n - 1$ routes are sufficient for $n$ nations.

Each nation imposes tariffs on goods to protect its domestic industries from
cheap foreign goods and predatory competition. In the Pacific, tariffs are
levied per unit of cargo: goods on a ship are taxed once at each route they
pass through. Different goods have different tax rates; for gold bricks, the
tariff is $c$ International Silver Coins per safe.

However, since the gold brick shipping business is mediocre, *all* nations
initially did not pay much attention to it and imposed no tariff on it.

Senior Cucumber is the CEO of a company called *"Why Don't Young People Like
Reading Classical Poetry"* that specializes in gold brick shipping. Since the
customer's nation and the nation from which gold bricks can be shipped differ,
the tariff charged may vary. He wants to charge a reasonable price to avoid
operating at a loss or being accused of price gouging in violation of fair
trade. He therefore needs to calculate how much tariff will be levied on a
given route.

Moreover, due to a recent financial crisis and a surging epidemic, many nations
that previously imposed no tariff have sensed an opportunity and started
levying tariffs. Senior Cucumber must constantly adjust his prices to account
for tariff changes, to prevent *"Why Don't Young People Like Reading Classical
Poetry"* from losing its competitive edge.

*Input Format*

The first line contains $2$ integers $n$ $q$, representing $n$ nations and $q$ operations.

The next $n - 1$ lines each contain $2$ integers $u$ $v$, indicating a direct
shipping route between nations $\( u \, v \)$.

The next $q$ lines each contain $3$ integers $o p$ $a$ $b$.

If $o p = 1$, Senior Cucumber has received an order (ship from nation $a$ to nation $b$).

Otherwise $o p = 2$, nation $a$ sets its tariff to $b$ International Silver Coins per safe.

$o p in upright("1,2")$, $n \, q$ $lt.eq 10^5$, $a \, b lt.eq n$

*Output Format*

For $o p = = 1$, output the total tariff (the exporting nation $\( a \)$ does
not levy tariff, but the importing nation $\( b \)$ does).

*Sample Test*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`7 10`#linebreak()`6 5`#linebreak()`7 5`#linebreak()`4 3`#linebreak()`4 5`#linebreak()`4 2`#linebreak()`6 1`#linebreak()`1 3 7`#linebreak()`1 3 1`#linebreak()`2 6 207`#linebreak()`1 7 4`#linebreak()`1 6 4`#linebreak()`2 2 683`#linebreak()`2 3 119`#linebreak()`1 5 6`#linebreak()`2 1 579`#linebreak()`2 1 947`], [`0`#linebreak()`0`#linebreak()`0`#linebreak()`0`#linebreak()`207`],
)
==== Problem: Luogu P2680 Transport Plan
*Problem Statement*

In the year 2044, humanity has entered the cosmic era.

Nation L has $n$ planets and $n - 1$ bidirectional space lanes, each built
between two planets. These $n - 1$ lanes connect all of L's planets.

Xiao P manages a logistics company that has many transport plans. Each plan
has the form: a logistics spaceship needs to travel from planet $u_i$ along
the fastest space route to planet $v_i$. Obviously, traveling a lane takes
time; for lane $j$, the time for any spaceship to traverse it is $t_j$, and
any two spaceships do not interfere with each other.

To encourage technological innovation, Nation L's king allows Xiao P's
logistics company to participate in the construction of Nation L's lanes,
specifically allowing Xiao P to convert one lane into a wormhole — a
spaceship traversing a wormhole takes zero time.

Before the wormhole is built, Xiao P's logistics company has already accepted
$m$ transport plans. After the wormhole is built, all $m$ plans start
simultaneously with all spaceships departing at the same time. When all $m$
transport plans are complete, Xiao P's company finishes its current phase of work.

If Xiao P can freely choose which lane to convert into a wormhole, what is
the minimum time for Xiao P's company to complete this phase of work?

*Input Format*

The first line contains two positive integers $n \, m$, the number of planets
in Nation L and the number of transport plans Xiao P's company has accepted.
Planets are numbered $1$ to $n$.

The next $n - 1$ lines describe the lanes. Line $i$ contains three integers
$a_i \, b_i$ and $t_i$, indicating that the $i$-th bidirectional lane is
built between planets $a_i$ and $b_i$ and takes time $t_i$ to traverse.

The next $m$ lines describe the transport plans. Line $j$ contains two
positive integers $u_j$ and $v_j$, indicating the $j$-th transport plan
travels from planet $u_j$ to planet $v_j$.

Data guarantees: $1 lt.eq a_i \, b_i lt.eq n$, $0 lt.eq t_i lt.eq 1000$, $1 lt.eq u_i \, v_i lt.eq n$.

*Output Format*

A single integer representing the minimum time for Xiao P's logistics company
to complete this phase of work.

*Sample Test*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`6 3`#linebreak()`1 2 3`#linebreak()`1 6 4`#linebreak()`3 1 7`#linebreak()`4 3 6`#linebreak()`3 5 5`#linebreak()`3 6`#linebreak()`2 5`#linebreak()`4 5`], [`11`],
)

#block[
Fast I/O is required; remember to refer back to the earlier sections.

]
