import pandas as pd
import pickle
import requests, json
import sys, os

from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.model_selection import train_test_split
from sklearn.naive_bayes import MultinomialNB
from sklearn.pipeline import Pipeline
from sklearn.metrics import accuracy_score

def send_slack(msg, channel="#dssf", username="provision_bot" ):
    webhook_URL = "https://hooks.slack.com/services/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"
    payload = {
        "channel": channel,
        "username": username,
        "icon_emoji": ":provision:",
        "text": msg,
    }
    response = requests.post(
        webhook_URL,
        data = json.dumps(payload),
    )
    return response

def find_accuracy(alpha):

    # 기사 데이터 프레임 로드
    article_df = pd.read_csv("article.csv")

    # 테스트 데이터와 트레인 데이터 분리
    X_train, X_test, y_train, y_test = train_test_split(article_df.content, article_df.category, test_size=0.1, random_state=1)

    # vectorizer와 classification algorithm 설정
    clf = Pipeline([
        ('vect', TfidfVectorizer()),
        ('clf', MultinomialNB(alpha=float(alpha)))
    ])

    # 모델 생성
    model = clf.fit(X_train, y_train)

    # 테스트 데이터 예측 결과 출력
    y_pred = model.predict(X_test)

    # 정확도 확인
    result = accuracy_score(y_test, y_pred)
    send_slack("alpha:{}, accuracy:{}".format(alpha, result))
    return result

result = find_accuracy(sys.argv[1])
print(result)

