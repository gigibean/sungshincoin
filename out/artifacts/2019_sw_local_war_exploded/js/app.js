App = {
    web3Provider: null, //web3연결
    contracts: {},
    account: '0x0',
    App_account: '0x0',
    AppSale_account: '0x0',
    loading: false,
    tokenPrice: 1000000000000000,
    tokensSold: 0,
    tokensAvailable: 920000,

    init: function () {
        console.log("App initialized...");
        //return App.initWeb3();
        return App.initWeb3();
    },
//web3 연결!!!
    initWeb3: function () {
        if (typeof web3 !== 'undefined') {
            //메타마스크 존재하면(주어진 web3인스턴스 있다면)
            App.web3Provider = web3.currentProvider; //현재 사용자를 가져온다.
            web3 = new Web3(web3.currentProvider); //web3에 담는다.
        } else {
            console.log("App initialized...3");
            //이 rpc서버를 제공하는 local공급자가 가나슈이면 가나슈가 실행
            App.web3Provider = new Web3.providers.HttpProvider('http://localhost:7545');
            web3 = new Web3(App.web3Provider);
        }
        return App.initContracts();
    }, //dapp에서 쓸수있는 web3환경 조성

//
    initContracts: function () {
        $.getJSON("DappTokenSale.json", function (dappTokenSale) {
            //artifact파일 abi정보와 컨트랙트 배포 주소 갖고 있음
            //크라우드세일의 주소를 가지고 오기
            App.contracts.DappTokenSale = TruffleContract(dappTokenSale);
            App.contracts.DappTokenSale.setProvider(App.web3Provider);
            App.contracts.DappTokenSale.deployed().then(function (dappTokenSale) {
                console.log("Token Crowdsale Address:", dappTokenSale.address);
                App.AppSale_account = dappTokenSale.address;
                console.log("Token Crowdsale Address:", App.AppSale_account);
                console.log("여기는 setProvider 입니다.   : " , App.web3Provider);
            });
        }).done(function () {
            $.getJSON("DappToken.json", function (dappToken) {
                //토큰이의 주소 가지고 오기
                App.contracts.DappToken = TruffleContract(dappToken);
                App.contracts.DappToken.setProvider(App.web3Provider);
                App.contracts.DappToken.deployed().then(function (dappToken) {
                    console.log("Token Address:", dappToken.address);

                    App.App_account = dappToken.address;
                    console.log("Token Address:", App.App_account);
                });

                App.listenForEvents();
                return App.render();
            });
        })
    },
    //스마트컨트랙트를 인스턴스화 그래야 web3가 우리 contract 어디서 찾아야하는지 알 수 잇음

    // 컨트랙트에서 부르는 이벤트를 리스닝 한다.
    listenForEvents: function () {
        App.contracts.DappTokenSale.deployed().then(function (instance) {
            instance.Sell({}, {
                fromBlock: 0,
                toBlock: 'latest' //(,)
            }).watch(function (error, event) {
                console.log("event triggered", event);
                App.render();
            })
        })
    },

    render: function () {
        if (App.loading) {
            return;
        } else {
            App.loading = true;

            var loader = $('#loader');
            var content = $('#content');

            loader.show();
            content.hide();

            // Load account data
            // web3 통해 연결된 노드 계정 불러와야
            // 사용자의 계정을 가지고 와서 account에 담는다.
            web3.eth.getCoinbase(function (err, account) {
                if (err === null) {
                    App.account = account;
                    $('#accountAddress').html(account);
                }
            });

            // token 컨트랙트 실행
            App.contracts.DappTokenSale.deployed().then(function (instance) {
                dappTokenSaleInstance = instance;
                return dappTokenSaleInstance.tokenPrice();
            }).then(function (tokenPrice) {
                App.tokenPrice = tokenPrice;
                $('.token-price').html(web3.fromWei(App.tokenPrice, "ether").toNumber());
                return dappTokenSaleInstance.tokensSold();
            }).then(function (tokensSold) {
                App.tokensSold = tokensSold.toNumber();
                $('.tokens-sold').html(App.tokensSold);
                console.log("여기는 token-sold입니다" + App.tokensSold);
                $('.tokens-available').html(App.tokensAvailable);
                console.log("여기는 tokens-avialable" + App.tokensAvailable);

                var progressPercent = (Math.ceil(App.tokensSold) / App.tokensAvailable) * 100;
                $('#progress').css('width', progressPercent + '%');

                // 토큰컨트랙트
                App.contracts.DappToken.deployed().then(function (instance) {
                    dappTokenInstance = instance;
                    console.log("here : " + instance);
                    console.log("here2222 : " + dappTokenInstance);
                    console.log("여기서 balanceof가 무슨 값을 가져오냐면   : " , dappTokenInstance.balanceOf(App.account));
                    return dappTokenInstance.balanceOf(App.account);
                }).then(function (balance) {
                    $('.dapp-balance').html(balance.toNumber());
                    // $('.tokens-sold').html(balance.toNumber());
                    console.log("여기는 balance 입니다   :" , balance.toNumber());
                    App.loading = false;
                    loader.hide();
                    content.show();
                });

                // App.contracts.DappToken.deployed().then(function (instance) {
                //     dappTokenInstance = instance;
                //     return dappTokenInstance.totalSupply();
                //
                // }).then(function (totalSupply) {
                //     $('.dapp-balance').html(totalSupply.toNumber());
                //     console.log("여기는 토탈!!!!! 입니다   :" + totalSupply);
                //     App.loading = false;
                //     loader.hide();
                //     content.show();
                // });
            });
        }
    },
    // 이자의 잔액이 있는지 없는지 확인.
    // 돈만 나가면 됨.
    TransferSSTokens: function () {
        var total_bill = $('#total_bill').val();
        App.contracts.DappToken.deployed().then(function (instance) {
            instance.transfer(App.App_account, total_bill);
            if (instance.transfer == false) {
                alert("수정구슬이 부족합니다");
            } else {
                return instance.transfer(App.App_account, total_bill);
            }
        })
    },

    buyTokensBtn: function () {
        $('#content').hide();
        $('#loader').show();
        var numberOfTokens = $('#numberOfTokens').val();
        console.log("여기는 numberoftokens?    :" + numberOfTokens);
        App.contracts.DappTokenSale.deployed().then(function (instance) {
            console.log("여기는 app.contracts.dapp 어쩌구 인데    : ", instance);
            console.log("여기는 아니야..제발.. :      " + numberOfTokens);
            instance.buyTokens(numberOfTokens, {
                from: App.account,
                value: numberOfTokens * App.tokenPrice,
                gas: 50000 // Gas 설정
            });
        }).then(function (result) {
            console.log("Tokens bought...");
            $('form').trigger('reset') // reset number of tokens in form
            // Sell event 기다리기.
        });
    }
};
// web3.eth.sendTransction(App, function(err, res) {
//     if(err) {
//         console.log(err);
//     }else {
//         res = "0x.."
//     }
// });
// exports.checkTransaction = function(id, callback) {
//     if(web3.eth.getTransaction(id) !== null) {
//         console.log('mining done');
//         return callback(null, id);
//     }
//     setTimeout(function() {
//         if(web3.eth.getTransaction(id) !== null) {
//             clearTimeout(timer);
//             return callback(id);
//         }
//     },3000);
//     this.checkTransaction(id, callback);
// };
$(function () {
    $(window).load(function () {
        App.init();
    })
});
