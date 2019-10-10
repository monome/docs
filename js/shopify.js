function ShopifyBuyInit() {

    var client = ShopifyBuy.buildClient({
        domain: 'monome.myshopify.com',
        apiKey: '54686b55d507067316908858df83ace3',
        appId: '6',
    });

    ShopifyBuy.UI.onReady(client).then(function (ui) {

        jQuery(".spfy-buy-button").each(function () {

            elementId = '';
            productId = jQuery(this).attr("data-id");
            varId = jQuery(this).attr("data-var");
            elementId = productId;
            elementTitle = jQuery(this).attr("data-title");
            stockText = jQuery(this).attr("data-stock");

            ui.createComponent('product', {
                id: [parseInt(productId)],
                node: document.getElementById(elementId),
                moneyFormat: '%24%7B%7Bamount%7D%7D',
                options: {
                    "product": {
                        "variantId": varId,
                        "contents": {
                            "img": false,
                              "imgWithCarousel": false,
                              "title": false,
                              "price": false,
                              "description": false,
                              "buttonWithQuantity": false,
                              "quantity": false,
                        },
                        "styles": {
                            "product": {
                                "text-align": "left",
                                "display": "inline",
                                "float": "left",
                                "width": "auto",
                                "padding": "0",
                                "margin": "0"
                            },
                            "button": {
                                "background-color": "rgba(0, 0, 0, 0)",
                                "color": "#443e3c",
                                "position": "relative",
                                "top": "-15px",
                                "font-family": "Roboto, sans-serif",
                                "font-weight": "400",
                                "font-size": "12px",
                                "line-height": "1",
                                "text-transform": "uppercase",
                                "letter-spacing": "1.5px",
                                "display": "inline",
                                "border-bottom": "1px solid #e0e0e0",
                                "padding": "0",
                                "padding-bottom": "8px",
                                "margin": "0",
                                "text-align": "left",
                                ":disabled": {
                                    "background-color": "rgba(0, 0, 0, 0)"
                                },
                                ":hover": {
                                  "background-color": "rgba(0, 0, 0, 0)"
                                },
                                ":focus": {
                                  "background-color": "rgba(0, 0, 0, 0)"
                                }
                            }
                        },
                        "text": {
                            "button": elementTitle,
                            "outOfStock": stockText
                        }
                    },

                        "cart": {
                            "contents": {
                            "button": true
                            },
                            "styles": {
                            "button": {
                                "background-color": "#222222",
                                "color": "#dddddd",
                                "font-family": "Roboto, sans-serif",
                                "font-size": "12px",
                                "letter-spacing": "1.5px",
                                "padding-top": "15px",
                                "padding-bottom": "15px",
                                ":hover": {
                                "background-color": "#3a3a3a",
                                "color": "#dddddd"
                                },
                                "border-radius": "0px",
                                "font-weight": "bold",
                                ":focus": {
                                "background-color": "#3a3a3a"
                                }
                            },
                            "footer": {
                                "background-color": "#ffffff"
                            }
                            }
                        },

                      "toggle": {
                        "styles": {
                        "toggle": {
                            "font-family": "Roboto, sans-serif",
                            "background-color": "#222222",
                            "z-index": "10",
                            ":hover": {
                            "background-color": "#3a3a3a"
                            },
                            "font-weight": "bold",
                            ":focus": {
                            "background-color": "#3a3a3a"
                            }
                        },
                        "count": {
                            "font-size": "14px",
                            "color": "#dddddd",
                            ":hover": {
                            "color": "#dddddd"
                            }
                        },
                        "iconPath": {
                            "fill": "#dddddd"
                        }
                        },
                        "googleFonts": [
                        "Roboto"
                        ]
                    },
                    "productSet": {
                        "styles": {
                            "products": {
                                "@media (min-width: 601px)": {
                                    "margin-left": "-20px"
                                }
                            }
                        }
                    }
                }
            });
        });
    });
}

jQuery(document).ready(function () {
    ShopifyBuyInit();
});