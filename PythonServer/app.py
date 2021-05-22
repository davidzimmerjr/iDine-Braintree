from flask import Flask, redirect, url_for, render_template, request, flash
from collections import Counter
import os
from os.path import join, dirname
from dotenv import load_dotenv
import braintree
from gateway import generate_client_token, transact, find_transaction

load_dotenv()

app = Flask(__name__)
app.secret_key = os.environ.get('APP_SECRET_KEY')

gateway = braintree.BraintreeGateway(
    braintree.Configuration(
        braintree.Environment.Sandbox,
        merchant_id="3zn8nqpgrcyk5g36",
        public_key="32ksn78tzqqcvqk6",
        private_key="ac789bf386b16b850c34855e8f57a119"
    )
)



TRANSACTION_SUCCESS_STATUSES = [
    braintree.Transaction.Status.Authorized,
    braintree.Transaction.Status.Authorizing,
    braintree.Transaction.Status.Settled,
    braintree.Transaction.Status.SettlementConfirmed,
    braintree.Transaction.Status.SettlementPending,
    braintree.Transaction.Status.Settling,
    braintree.Transaction.Status.SubmittedForSettlement
]

@app.route('/', methods=['GET'])
def index():
    return redirect(url_for('new_checkout'))

@app.route('/checkouts/new', methods=['GET'])
def new_checkout():
    client_token = generate_client_token()
    return render_template('checkouts/new.html', client_token=client_token)

@app.route('/checkouts/<transaction_id>', methods=['GET'])
def show_checkout(transaction_id):
    print("hit show_checkout(). Here is transaction_id " + transaction_id)
    transaction = find_transaction(transaction_id)
    print("show_checkout after transaction")
    result = {}
    print("show_checkout after result")
    if transaction.status in TRANSACTION_SUCCESS_STATUSES:
        result = {
            'header': 'Sweet Success!',
            'icon': 'success',
            'message': 'Your test transaction has been successfully processed. See the Braintree API response and try again.'
        }
    else:
        result = {
            'header': 'Transaction Failed',
            'icon': 'fail',
            'message': 'Your test transaction has a status of ' + transaction.status + '. See the Braintree API response and try again.'
        }
    print("show_checkout after if", result)
    return render_template('checkouts/show.html', transaction=transaction, result=result)

@app.route('/checkouts', methods=['POST'])
def create_checkout():
    # print("hit /checkouts ", request.is_json, flush=True)
    print(request.json)
    # print(request.json.get("nonce"))
    # print(request.json.get("total"))
    nonce_from_the_client = request.json.get("nonce")
    amount = request.json.get("total")
    name_counter = dict(Counter(request.json.get("names")))
    for key, value in name_counter.items():
        print(value, "x ", key)
    print("name_counter ", name_counter)
    print("list() ", list(name_counter))
    print(".items() ", name_counter.items())
    print("dict() ", dict(name_counter))
    print("set() ", set(name_counter))
    result = gateway.transaction.sale({
    "amount": amount,
    "payment_method_nonce": nonce_from_the_client,
    #"device_data": device_data_from_the_client,
    "options": {
      "submit_for_settlement": True
        }
    })
    print("result app.py", result)
    if result.is_success or result.transaction:
        print("success /checkouts", flush=True)
        return redirect(url_for('show_checkout',transaction_id=result.transaction.id))
    else:
        print("fail /checkouts", flush=True)
        for x in result.errors.deep_errors: flash('Error: %s: %s' % (x.code, x.message))
        return redirect(url_for('new_checkout'))

if __name__ == '__main__':
    app.run(debug=True)
