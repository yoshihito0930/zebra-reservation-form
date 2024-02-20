package main

import (
	"context"
	"fmt"
	"os"

	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/ses"
)

type FormEvent struct {
	Subject string `json:"subject"`
	Email   string `json:"email"`
	Body    string `json:"body"`
}

func Email(ctx context.Context, event FormEvent) error {
	cfg, err := config.LoadDefaultConfig(ctx)
	if err != nil {
		return err
	}

	sesClient := ses.NewFromConfig(cfg)

	adminAddress := "yoshihito.093079@gmail.com"
	input := &ses.SendEmailInput{
		Destination: &ses.Destination{
			ToAddresses: []string{adminAddress},
		},
		Message: &ses.Message{
			Body: &ses.Body{
				Text: &ses.Content{
					Data: aws.String(fmt.Sprintf("[お問い合わせ表題] : %s\n[メールアドレス] : %s\n[お問い合わせ本文] : \n%s", event.Subject, event.Email, event.Body)),
				},
			},
			Subject: &ses.Content{
				Data: aws.String("フォームからのお問い合わせ"),
			},
		},
		Source: aws.String("yoshihito.093079@gmail.com"),
	}

	_, err = sesClient.SendEmail(ctx, input)
	return err
}